//
//  MainViewModel.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/7/21.
//

import Foundation

@MainActor
final class WeatherViewModel {
    
    private let entityName = "WeatherEntity"
    
    var currentCoordinate: (Float, Float) = Constants.hcmCoordinate
    
    var isNetworkBack = true
    
    lazy var arrWeather = {
        return [Weather]()
    }()
    
    // MARK: Load Local Data
    private func loadLocalData(completionHandler: @MainActor @escaping (String) -> Void) async {
        let dataManager = DataManager.shared
        do {
            self.arrWeather = try await dataManager.fetchAllWeathers()
            completionHandler("")
        } catch {
            completionHandler(error.localizedDescription)
        }
    }
    
    // MARK: Fetch Data From Server
    func fetchWeather(completionHandler: @escaping(String) -> Void) async {
        let apiManager = ApiManager.shared
        let strUrl = Constants.apiRootPath + Constants.apiWeather
        
        guard ApiManager.weatherServiceApiKey != "" else  {
            completionHandler(String.stringByKey(key: .dialogLostInternet))
            return
        }
        
        let params: [String: String] = ["lat": "\(self.currentCoordinate.0)", "lon": "\(self.currentCoordinate.1)",
                                        "units": "metric", "appid": ApiManager.weatherServiceApiKey]
        
        let result = await apiManager.getRequest(url: strUrl, params: params)
        
        switch result {
        case .success(let data):
            let jsonDecoder = JSONDecoder()
            do {
                let weathers = try jsonDecoder.decode(Weather.self, from: data)
                await self.filterData(newWeather: [weathers], handler: completionHandler)
            } catch {
                await self.loadLocalData(completionHandler: completionHandler)
            }
        case .failure(_):
            await self.loadLocalData(completionHandler: completionHandler)
        default:
            break
        }
    }
    
    func findCityBy(keyword: String, completionHandler: @MainActor @escaping ([Coordinate]) -> Void) async {
        let apiManager = ApiManager.shared
        let strUrl = Constants.apiRootPath + Constants.apiLocation
        let params = ["q": keyword, "limit": "1", "appid": ApiManager.weatherServiceApiKey]
        let result = await apiManager.getRequest(url: strUrl, params: params)
        switch result {
        case .success(let data):
            let jsonDecoder = JSONDecoder()
            do {
                let locations = try jsonDecoder.decode([Coordinate].self, from: data)
                completionHandler(locations)
            } catch {
                print(error.localizedDescription)
                completionHandler([])
            }
        case .failure(let err):
            print(err.localizedDescription)
            completionHandler([])
        case .none:
            break
        }
    }
    
    // MARK: Filter Data
    private func filterData(newWeather: [Weather], handler: @MainActor @escaping (String) -> Void) async {
        let newCityName = newWeather.first?.cityName ?? ""
        let sameCityName = self.arrWeather.filter { $0.cityName == newCityName }
        if sameCityName.isEmpty {
            self.arrWeather.append(contentsOf: newWeather)
            if !self.arrWeather.isEmpty {
                await self.insertAllData(filteredWeather: self.arrWeather)
                handler("")
            } else {
                handler("false")
            }
        }
    }
    
    // MARK: Insert Data
    private func insertAllData(filteredWeather: [Weather]) async {
        guard !filteredWeather.isEmpty else { return }
        let dataManager = DataManager.shared
        do {
            if try await dataManager.deleteAllData(entityName: entityName) {
                for weather in filteredWeather {
                    try await dataManager.insertWeather(weather: weather)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
