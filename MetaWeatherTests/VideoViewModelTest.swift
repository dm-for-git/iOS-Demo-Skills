//
//  MainViewModelTest.swift
//  MetaWeatherTests
//
//  Created by DavidMartin on 8/8/21.
//

import XCTest
@testable import MetaWeather

class VideoViewModelTest: XCTestCase {

    func testFetchData() {
        // Given
        let viewModel = VideoViewModel()
        let promise = expectation(description: "Finished request data")
        
        // When
        viewModel.fetchMoreData { isSuccess in
            XCTAssertTrue(isSuccess == true)
        }
        
        // Then
        wait(for: [promise], timeout: 5)
    }

    func testFetchDataPerformance() {
        self.measure {
           testFetchData()
        }
    }

}
