//
//  DataManager.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation
import CoreData
import UIKit

@MainActor
class DataManager: @MainActor NSCopying {
    
    static let shared = DataManager()
    
    // Prevent instance of this object to be cloned because this class serves as a Singleton
    nonisolated func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
    func insertWeather(weather: Weather) async throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw CustomError.nilError
        }
        let context = appDelegate.persistentContainer.viewContext
        // Do Core Data work on the context's queue
        do {
            try await context.perform {
                let weatherEntity = WeatherEntity(context: context)
                weatherEntity.currentTemp = weather.currentTemp ?? 0
                weatherEntity.maxTemp = weather.maxTemp ?? 0
                weatherEntity.minTemp = weather.minTemp ?? 0
                weatherEntity.weatherStatus = weather.status
                weatherEntity.cityName = weather.cityName
                weatherEntity.iconCode = weather.iconCode
                try context.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchAllWeathers() async throws -> [Weather] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw CustomError.nilError
        }

        let context = appDelegate.persistentContainer.viewContext

        return try await context.perform {
            let request = WeatherEntity.fetchRequest()
            let weatherEntities = try context.fetch(request)
            guard !weatherEntities.isEmpty else {
                throw CustomError.nilError
            }
            return weatherEntities.map { item in
                var weather = Weather()
                weather.currentTemp = item.currentTemp
                weather.maxTemp = item.maxTemp
                weather.minTemp = item.minTemp
                weather.cityName = item.cityName
                weather.status = item.weatherStatus
                weather.iconCode = item.iconCode
                return weather
            }
        }
    }
    
    func deleteAllData(entityName: String) async throws -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw CustomError.nilError
        }

        let context = appDelegate.persistentContainer.viewContext
        do {
            try await context.perform {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try context.execute(batchDeleteRequest)
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}

