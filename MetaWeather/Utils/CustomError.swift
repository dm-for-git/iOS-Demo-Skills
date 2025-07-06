//
//  CustomError.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation

enum CustomError: Error, CustomStringConvertible, Sendable {
    var description: String {
        switch self {
        case .invalidUrl:
            return "The URL is incorrect!!!"
        case .fileError:
            return "An error has been occurred"
        case .networkError:
            return "Your internet connection has problem"
        case .tokenMissing:
            return "Service token is missing"
        case .serverError:
            return "Server is temporary unavailable now"
        case .nilError:
            return "You're trying to access a NIL value!!!"
        }
    }
    
    case invalidUrl
    case networkError
    case fileError
    case tokenMissing
    case serverError
    case nilError
}
