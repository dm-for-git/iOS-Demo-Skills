//
//  NSLocalizedString+.swift
//  MetaWeather
//
//  Created by David Martin on 25/01/2022.
//

import Foundation

extension String {
    static func stringByKey(key: LocalizableKeys) -> String {
        return NSLocalizedString(key.rawValue, comment: "")
    }
}
