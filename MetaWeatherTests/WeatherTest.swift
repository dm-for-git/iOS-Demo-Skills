//
//  WeatherTest.swift
//  MetaWeatherTests
//
//  Created by DavidMartin on 8/8/21.
//


import XCTest
@testable import MetaWeather

class WeatherTest: XCTestCase {
    
    var arrWeather: [Weather]?

    override func setUpWithError() throws {
        // Prepare resources for testing
        if let data = TestUtils.readJsonFromFileOf(bundle: Bundle(for: type(of: self)), usingFileName: "weathers") {
            arrWeather = try! JSONDecoder().decode([Weather].self, from: data)
        }
    }

    override func tearDownWithError() throws {
        // Cleanup all resources
        arrWeather =  nil
    }
    
    // MARK: Logic Testing
    func testJsonDecoding() {
        // Given
        var isEmpty = true
        // When
        isEmpty = arrWeather?.isEmpty ?? false
        // Then
        XCTAssertFalse(isEmpty)
    }
    
    func testEncoding() {
        // Given
        var weather = Weather()
        weather.currentTemp = 25
        weather.maxTemp = 30
        weather.minTemp = 21
        weather.lastUpdated = "12:41"
        weather.stateAbbr = "sn"
        weather.stateName = "Snow"
        
        var result = ""
        
        // When
        let encodedData = try! JSONEncoder().encode(weather)
        result = String(data: encodedData, encoding: .utf8) ?? ""
        
        // Then
        XCTAssertTrue(result != "")
    }

    
    // MARK: Performance testing
    func testJsonParsingPerformance() throws {
        // This is an example of a performance test case.
        self.measure {
            testJsonDecoding()
        }
    }
    
    func testEncodingPerformance() {
        self.measure {
            testEncoding()
        }
    }

}
