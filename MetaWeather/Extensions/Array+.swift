//
//  Array+.swift
//  MetaWeather
//
//  Created by DavidMartin on 7/12/22.
//

import Foundation

extension Array where Element: Hashable {
    
    func differences(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
    
}
