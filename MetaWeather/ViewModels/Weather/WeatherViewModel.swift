//
//  MainViewModel.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/7/21.
//

import Foundation
import Synchronization

final class WeatherViewModel: Sendable {
    
    private let entityName = "WeatherEntity"
    
    private let _currentCoordinate = Mutex<Coordinate>(Constants.hcmCoordinate)
    
    var currentCoordinate: Coordinate {
        get { _currentCoordinate.withLock { $0 } }
        set { _currentCoordinate.withLock { $0 = newValue } }
    }
    
    let _isNetworkBack = Mutex<Bool>(true)
    
    var isNetworkBack: Bool {
        get { _isNetworkBack.withLock { $0 } }
        set { _isNetworkBack.withLock { $0 = newValue } }
    }
    
    // Using a Mutex to protect the array for Sendable conformance
    private let _arrWeather = Mutex<[Weather]>([])
    var arrWeather: [Weather] {
        get { _arrWeather.withLock { $0 } }
        set { _arrWeather.withLock { $0 = newValue } }
    }
    
    // MARK: Load Local Data
    private func loadLocalData() async -> String {
        let dataManager = DataManager.shared
        do {
            self.arrWeather = try await dataManager.fetchAllWeathers()
            return "" // Return an empty string on success
        } catch {
            return error.localizedDescription // Return the error message on failure
        }
    }
    
    // MARK: Fetch Data From Server
    func fetchWeather() async -> String {
        let apiManager = ApiManager.shared
        let strUrl = Constants.apiRootPath + Constants.apiWeather
        
        guard ApiManager.weatherServiceApiKey != "" else {
            return String.stringByKey(key: .errApiKeyIsMissing)
        }
        
        // Use a local copy for the network request to avoid locking during the await
        let coordinate = self.currentCoordinate
        let params: [String: String] = ["lat": "\(coordinate.latitude)",
                                        "lon": "\(coordinate.longitude)",
                                        "units": "metric", "appid": ApiManager.weatherServiceApiKey]
        
        let result = await apiManager.getRequest(url: strUrl, params: params)
        
        switch result {
        case.success(let data):
            let jsonDecoder = JSONDecoder()
            do {
                let weather = try jsonDecoder.decode(Weather.self, from: data)
                // Await the result from the refactored filterData function
                return await self.filterData(newWeather: [weather])
            } catch {
                // Await the result from the refactored loadLocalData function
                return await self.loadLocalData()
            }
        case.failure(_):
            // Await the result from the refactored loadLocalData function
            return await self.loadLocalData()
        }
    }
    
    func findCityBy(keyword: String) async -> [Coordinate] {
        let apiManager = ApiManager.shared
        let strUrl = Constants.apiRootPath + Constants.apiLocation
        let params = ["q": keyword, "limit": "1", "appid": ApiManager.weatherServiceApiKey]
        let result = await apiManager.getRequest(url: strUrl, params: params)
        
        switch result {
        case.success(let data):
            let jsonDecoder = JSONDecoder()
            do {
                let locations = try jsonDecoder.decode([Coordinate].self, from: data)
                return locations
            } catch {
                print(error.localizedDescription)
                return []
            }
        case.failure(let err):
            print(err.localizedDescription)
            return []
        }
    }
    
    // MARK: Filter Data
    private func filterData(newWeather: [Weather]) async -> String {
        guard let firstNewWeather = newWeather.first else {
            return "No new weather data to process." // Handle empty input
        }
        
        let newCityName = firstNewWeather.cityName
        
        // Use withLock to safely access the array
        let isNewCity = _arrWeather.withLock { weatherArray in
            !weatherArray.contains { $0.cityName == newCityName }
        }
        
        if isNewCity {
            // Safely append to the array
            _arrWeather.withLock { $0.append(firstNewWeather) }
            
            // The insert operation can happen concurrently
            await self.insertAllData(filteredWeather: self.arrWeather)
            return "" // Return empty string for success
        } else {
            // City already exists, so we do nothing and report success
            return ""
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
