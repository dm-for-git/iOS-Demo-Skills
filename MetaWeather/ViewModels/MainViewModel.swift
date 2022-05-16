//
//  MainViewModel.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/7/21.
//

import Foundation

class WeatherViewModel {
    
    var isNetworkBack = true
    
    lazy var arrWeather = {
        return [Weather]()
    }()
    
    // MARK: Load Local Data
    private func loadLocalData(completionHandler: @escaping(Bool) -> Void) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        
        queue.addOperation {[unowned self] in
            let dataManager = DataManager.shared
            dataManager.fetchAllWeathers { result in
                switch result {
                case .success(let weathers):
                    arrWeather = weathers
                    completionHandler(true)
                case .failure(let err):
                    print("Load local data fail: \(err.description)")
                    completionHandler(false)
                }
            }
        }
        queue.waitUntilAllOperationsAreFinished()
    }
    
    // MARK: Fetch Data From Server
    func fetchData(completionHandler: @escaping(Bool) -> Void) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        
        queue.addOperation {[unowned self] in
            let apiManager = ApiManager.shared
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let yesterday = dateFormatter.string(from: Date.yesterday)
            let strUrl = Constants.apiRootPath + Constants.apiYesterDayInfor + Constants.woeidBrisbane + "/" + yesterday
            
            apiManager.getRequest(url: strUrl, params: [:]) { result in
                switch result {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    do {
                        let weathers = try jsonDecoder.decode([Weather].self, from: data)
                        self.filterDateData(weathers: weathers, handler: { isSucess in
                            completionHandler(isSucess)
                        })
                    } catch {
                        print(error.localizedDescription)
                        completionHandler(false)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    loadLocalData { result in
                        completionHandler(result)
                    }
                    
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
    }
    
    // MARK: Filter Data
    private func filterDateData(weathers: [Weather], handler: @escaping(Bool) -> Void) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        
        queue.addOperation {[unowned self] in
            // "2021-08-06T23:59:58.252053Z"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let strYesterday = dateFormatter.string(from: Date.yesterday) + "T"
            queue.addOperation {
                arrWeather = weathers.filter {
                    $0.lastUpdated?.contains(strYesterday) ?? false
                }
            }
            
        }
        queue.waitUntilAllOperationsAreFinished()
        if !arrWeather.isEmpty {
            insertAllData(filteredWeather: arrWeather)
            handler(true)
        } else {
            handler(false)
        }
    }
    
    // MARK: Insert Data
    private func insertAllData(filteredWeather: [Weather]){
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        
        queue.addOperation {
            let dataManager = DataManager.shared
            dataManager.deleteAllData { result in
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
