//
//  DataManager.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation
import CoreData
import UIKit

class DataManager: NSCopying {
    
    static let shared = DataManager()
    
    // Prevent instance of this object to be cloned
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
    func insertWeather(weather: Weather, handler: @escaping(Result<Bool, CustomError>) -> Void) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                handler(.failure(.nilError))
                return
            }
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 3
            queue.addOperation {
                let context = appDelegate.persistentContainer.viewContext
                
                let weatherEntity = WeatherEntity(context: context)
                weatherEntity.currentTemp = weather.currentTemp ?? 0
                weatherEntity.maxTemp = weather.maxTemp ?? 0
                weatherEntity.minTemp = weather.minTemp ?? 0
                weatherEntity.weatherStatus = weather.status
                weatherEntity.cityName = weather.cityName
                weatherEntity.iconCode = weather.iconCode
                
                do {
                    try context.save()
                    handler(.success(true))
                } catch {
                    print("Data Error = \(error)")
                    handler(.failure(error as! CustomError))
                }
            }
            queue.waitUntilAllOperationsAreFinished()
        }
    }
    
    func fetchAllWeathers(handler: @escaping(Result<[Weather], CustomError>) -> Void) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                handler(.failure(.nilError))
                return
            }
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 3
            
            queue.addOperation {
                
                let context = appDelegate.persistentContainer.viewContext
                
                do {
                    let weatherEntities = try context.fetch(WeatherEntity.fetchRequest()) as? [WeatherEntity]
                    if let weatherEntities = weatherEntities, !weatherEntities.isEmpty {
                        var weathers = [Weather]()
                        weatherEntities.forEach { item in
                            var weather = Weather()
                            weather.currentTemp = item.currentTemp
                            weather.maxTemp = item.maxTemp
                            weather.minTemp = item.minTemp
                            weather.cityName = item.cityName
                            weather.status = item.weatherStatus
                            weather.iconCode = item.iconCode
                            weathers.append(weather)
                        }
                        handler(.success(weathers))
                    } else {
                        handler(.failure(.nilError))
                    }
                    
                } catch {
                    print("Data Error = \(error.localizedDescription)")
                    handler(.failure(error as! CustomError))
                }
            }
            queue.waitUntilAllOperationsAreFinished()
        }
    }
    
    func deleteAllData(entityName: String, handler: @escaping(Result<Bool, CustomError>) -> Void) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                handler(.failure(.nilError))
                return
            }
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 3
            
            queue.addOperation {
                
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                
                // Create Batch Delete Request
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do {
                    try context.execute(batchDeleteRequest)
                    handler(.success(true))
                } catch {
                    handler(.failure(error as! CustomError))
                }
            }
            queue.waitUntilAllOperationsAreFinished()
        }
    }
}
