//
//  CustomError.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation

enum CustomError: Error, CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidUrl:
            return "The URL is incorrect!!!"
        case .unknownError:
            return "An unexpected error occured"
        case .networkError:
            return "Error about internet connection"
        }
    }
    
    case invalidUrl
    case networkError
    case unknownError
}
