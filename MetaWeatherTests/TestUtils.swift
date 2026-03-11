//
//  TestUtils.swift
//  MetaWeatherTests
//
//  Created by DavidMartin on 8/8/21.
//

import Foundation

class TestUtils {
    // Read JSOn from file then return Data
    static func readJsonFromFileOf(bundle: Bundle, usingFileName fileName: String) -> Data? {
        do {
            if let bundlePath = bundle.path(forResource: fileName, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print("Reading JSON from file error = \(error)")
        }
        return nil
    }

    static func readXmlFromFileOf(bundle: Bundle, usingFileName fileName: String) -> Data? {
        do {
            if let bundlePath = bundle.path(forResource: fileName, ofType: "xml"),
                let xmlData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return xmlData
            }
        } catch {
            print("Reading XML from file error = \(error)")
        }
        return nil
    }
    
    
}


