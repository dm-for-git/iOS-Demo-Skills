//
//  Data+.swift
//  MetaWeather
//
//  Created by DavidMartin on 7/14/22.
//

import Foundation

extension Data {
    
    func toString() -> String {
        let tokenParts = self.map { data in
            String(format: "%02.2hhx", data)
        }
        return tokenParts.joined()
    }
}
