//
//  ApiManagerTest.swift
//  MetaWeatherTests
//
//  Created by DavidMartin on 8/8/21.
//

import XCTest
@testable import MetaWeather

class ApiManagerTest: XCTestCase {

    func testGetRequest() {
        // Given
        let promise = expectation(description: "Finished GET request")
        let apiManager = ApiManager.shared
        let strUrl = Constants.apiRootPath + Constants.apiLocation + Constants.woeId + "/" + "2021/08/08"
        
        // When
        apiManager.getRequest(url: strUrl, params: [:]) { result in
            switch result {
            case .success(_):
                promise.fulfill()
            default:
                break
            }
        }
        
        // Then
        wait(for: [promise], timeout: 5)
    }

    func testPerformanceExample() {
        self.measure {
            testGetRequest()
        }
    }

}
