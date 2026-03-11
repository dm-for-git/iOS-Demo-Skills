//
//  Weather.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation

struct Weather: Decodable, Hashable {
    var currentTemp: Float?
    var maxTemp: Float?
    var minTemp: Float?
    var cityName: String?
    var status: String?
    var iconCode: String?
    
    enum CodingKeys: String, CodingKey {
        case currentTemp = "temp"
        case maxTemp = "temp_max"
        case minTemp = "temp_min"
        case cityName = "name"
        // Middleman keys
        case main
        case weather
        
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cityName = try values.decodeIfPresent(String.self, forKey: .cityName)
        
        let mainContainer = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .main)
        
        currentTemp = try mainContainer.decodeIfPresent(Float.self, forKey: .currentTemp)
        maxTemp = try mainContainer.decodeIfPresent(Float.self, forKey: .maxTemp)
        minTemp = try mainContainer.decodeIfPresent(Float.self, forKey: .minTemp)
        
        let innerWeather = try values.decodeIfPresent([InnerWeather].self, forKey: .weather)
        if let innerWeather = innerWeather?.first {
            status = innerWeather.innerStatus
            iconCode = innerWeather.innerIconCode
        }
    }
    
    init() {
        
    }
    
    private struct InnerWeather: Decodable {
        let innerStatus: String
        let innerIconCode: String
        
        private enum InnerCodingKeys: String, CodingKey {
            case innerStatus = "description"
            case innerIconCode = "icon"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: InnerCodingKeys.self)
            innerStatus = try values.decodeIfPresent(String.self, forKey: .innerStatus) ?? ""
            innerIconCode = try values.decodeIfPresent(String.self, forKey: .innerIconCode) ?? ""
        }
    }
    
}
