//
//  NewsHeaderTest.swift
//  MetaWeatherTests
//
//  Created by David Martin on 25/02/2022.
//

import XCTest
import Network
@testable import MetaWeather

class NewsHeaderTest: XCTestCase {

    var arrNewsHeader: [NewsHeader]?
    var xmlParser: XmlParser?
    
    override func setUpWithError() throws {
        if let data = TestUtils.readXmlFromFileOf(bundle: Bundle(for: type(of: self)), usingFileName: "news") {
            xmlParser = XmlParser()
            xmlParser?.xmlParser = XMLParser(data: data)
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        xmlParser = nil
        arrNewsHeader = nil
    }

    func testParsing() {
        // Given
        arrNewsHeader = []
        // When
        xmlParser?.startParsing()
        xmlParser?.completionHandler = {[weak self] result in
            self?.arrNewsHeader = result
            // Then
            XCTAssertFalse(self?.arrNewsHeader?.isEmpty ?? false)
        }
    }

    func testParsingPerformance() {
        // This is an example of a performance test case.
        self.measure {
            testParsing()
        }
    }

}
