//
//  MainViewModel.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/7/21.
//

import Foundation

final class WeatherViewModel {
    
    var currentCoordinate: (Float, Float) = Constants.hcmCoordinate
    
    var isNetworkBack = true
    
    lazy var arrWeather = {
        return [Weather]()
    }()
    
    // MARK: Load Local Data
    private func loadLocalData(completionHandler: @escaping(String) -> Void) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        
        queue.addOperation {[weak self] in
            let dataManager = DataManager.shared
            dataManager.fetchAllWeathers { result in
                switch result {
                case .success(let weathers):
                    self?.arrWeather = weathers
                    completionHandler("")
                case .failure(let err):
                    print("Load data fail: \(err.localizedDescription)")
                    completionHandler(err.localizedDescription)
                }
            }
        }
        queue.waitUntilAllOperationsAreFinished()
    }
    
    // MARK: Fetch Data From Server
    func fetchWeather(completionHandler: @escaping(String) -> Void) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        
        queue.addOperation {[unowned self] in
            let apiManager = ApiManager.shared
            let strUrl = Constants.apiRootPath + Constants.apiWeather
            
            guard ApiManager.weatherServiceApiKey != "" else  {
                completionHandler(String.stringByKey(key: .dialogLostInternet))
                return
            }
            
            let params: [String: String] = ["lat": "\(currentCoordinate.0)", "lon": "\(currentCoordinate.1)",
                                            "units": "metric", "appid": ApiManager.weatherServiceApiKey]
            
            apiManager.getRequest(url: strUrl, params: params) {[weak self] result in
                switch result {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    do {
                        let weathers = try jsonDecoder.decode(Weather.self, from: data)
                        self?.filterData(newWeather: [weathers], handler: completionHandler)
                    } catch {
                        self?.loadLocalData { result in
                            completionHandler(result)
                        }
                    }
                case .failure(_):
                    self?.loadLocalData { result in
                        completionHandler(result)
                    }
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
    }
    
    func findCityBy(keyword: String, completionHandler: @escaping([Coordinate]) -> Void) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        
        queue.addOperation {
            let apiManager = ApiManager.shared
            // https://api.openweathermap.org/geo/1.0/direct?q=Toronto&limit=1&appid=bb587f64faaba88b43cc87e8141cc000
            let strUrl = Constants.apiRootPath + Constants.apiLocation
            let params = ["q": keyword, "limit": "1", "appid": ApiManager.weatherServiceApiKey]
            apiManager.getRequest(url: strUrl, params: params) { result in
                switch result {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    do {
                        let locations = try jsonDecoder.decode([Coordinate].self, from: data)
                        completionHandler(locations)
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                    completionHandler([])
                }
            }
        }
        queue.waitUntilAllOperationsAreFinished()
    }
    
    // MARK: Filter Data
    private func filterData(newWeather: [Weather], handler: @escaping(String) -> Void) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3

        queue.addOperation {[weak self] in
            queue.addOperation {
                let newCityName = newWeather.first?.cityName ?? ""
                let sameCityName = self?.arrWeather.filter { $0.cityName == newCityName } ?? []
                if sameCityName.isEmpty {
                    self?.arrWeather.append(contentsOf: newWeather)
                }
            }
        }
        queue.waitUntilAllOperationsAreFinished()
        if !arrWeather.isEmpty {
            insertAllData(filteredWeather: arrWeather)
            handler("")
        } else {
            handler("false")
        }
    }
    
    // MARK: Insert Data
    private func insertAllData(filteredWeather: [Weather]){
        guard !filteredWeather.isEmpty else { return }
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        
        queue.addOperation {
            let dataManager = DataManager.shared
            dataManager.deleteAllData(entityName: "WeatherEntity") { result in
                filteredWeather.forEach { weather in
                    dataManager.insertWeather(weather: weather) { result in
                        switch result {
                        case .failure(let err):
                            print("Insert data fail: \(err.description)")
                        default:
                            break
                        }
                    }
                }
            }
        }
        queue.waitUntilAllOperationsAreFinished()
    }
    
}
