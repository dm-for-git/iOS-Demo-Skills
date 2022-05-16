//
//  DataManagerTest.swift
//  MetaWeatherTests
//
//  Created by DavidMartin on 8/8/21.
//

import XCTest
@testable import MetaWeather

class DataManagerTest: XCTestCase {
    
    // MARK: Logic Testing
    func testInsertData() {
        // Given
        let promise = expectation(description: "Insert data successfully")
        
        let dbManager = DataManager.shared
        var weather = Weather()
        weather.currentTemp = 25
        weather.maxTemp = 30
        weather.minTemp = 21
        weather.lastUpdated = "12:41"
        weather.stateAbbr = "sn"
        weather.stateName = "Snow"
        
        // When
        dbManager.insertWeather(weather: weather) { result in
            switch result {
            case .success(_):
                promise.fulfill()
            default:
                break
            }
        }
        // Then
        wait(for: [promise], timeout: 1)
    }
    
    func testGetAllData() {
        // Given
        let promise = expectation(description: "Finished get data")
        let dbManager = DataManager.shared
        testInsertData()
        
        var count = 0
        
        // When
        dbManager.fetchAllWeathers { result in
            switch result {
            case .success(let weathers):
                count = weathers.count
                promise.fulfill()
            default:
                break
            }
        }
        
        // Then
        wait(for: [promise], timeout: 1)
        XCTAssertTrue(count > 0)
    }
    
    func testDeleteAllData() {
        // Given
        let promise = expectation(description: "Finished delete all data")
        let dbManager = DataManager.shared
        testInsertData()
        
        // When
        dbManager.deleteAllData { result in
            switch result {
            case .success(_):
                promise.fulfill()
            default:
                break
            }
        }
        
        // Then
        wait(for: [promise], timeout: 1)
    }

    // MARK: Performance testing
    func testInsertDataPerformance() throws {
        self.measure {
            testInsertData()
        }
    }
    
    func testGetDataPerformance() {
        self.measure {
            testGetAllData()
        }
    }
    
    func testDeleteDataPerformance() {
        self.measure {
            testDeleteAllData()
        }
    }

}
