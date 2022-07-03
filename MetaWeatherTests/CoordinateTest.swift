//
//  CoordinateTest.swift
//  MetaWeatherTests
//
//  Created by DavidMartin on 7/3/22.
//

import XCTest
@testable import MetaWeather

class CoordinateTest: XCTestCase {
    
    var coordinate: Coordinate?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coordinate = Coordinate(latitude: 0, longitude: 0)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        coordinate = nil
    }
    
    func testDecoding() {
        // Given
        if let data = TestUtils.readJsonFromFileOf(bundle: Bundle(for: type(of: self)), usingFileName: "coordinate") {
            do {
                coordinate = try JSONDecoder().decode(Coordinate.self, from: data)
            } catch {
                print(error)
            }
        }
        // When
        
        
        // Then
        XCTAssertTrue(coordinate != nil)
        XCTAssertTrue(coordinate?.latitude ?? 0 > 0)
        XCTAssertTrue(coordinate?.longitude ?? 0 > 0)
    
    }
    
    func testDecodingPerformance() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            testDecoding()
        }
    }
    
}
