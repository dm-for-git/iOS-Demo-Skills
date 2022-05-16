//
//  Weather.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation

/*
 {
 "id": 4565229036896256,
 "weather_state_name": "Showers",
 "weather_state_abbr": "s",
 "created": "2021-08-05T21:56:16.785774Z",
 "min_temp": 13.695,
 "max_temp": 18.555,
 "the_temp": 18
 }
 */
struct Weather: Codable {
    var currentTemp: Float?
    var maxTemp: Float?
    var minTemp: Float?
    var stateName: String?
    var stateAbbr: String?
    var lastUpdated: String?
    
    enum CodingKeys: String, CodingKey {
        case currentTemp = "the_temp"
        case maxTemp = "max_temp"
        case minTemp = "min_temp"
        case stateName = "weather_state_name"
        case stateAbbr = "weather_state_abbr"
        case lastUpdated = "created"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(currentTemp, forKey: .currentTemp)
        try container.encodeIfPresent(maxTemp, forKey: .maxTemp)
        try container.encodeIfPresent(minTemp, forKey: .minTemp)
        try container.encodeIfPresent(stateName, forKey: .stateName)
        try container.encodeIfPresent(stateAbbr, forKey: .stateAbbr)
        try container.encodeIfPresent(lastUpdated, forKey: .lastUpdated)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        currentTemp = try values.decodeIfPresent(Float.self, forKey: .currentTemp)
        maxTemp = try values.decodeIfPresent(Float.self, forKey: .maxTemp)
        minTemp = try values.decodeIfPresent(Float.self, forKey: .minTemp)
        stateName = try values.decodeIfPresent(String.self, forKey: .stateName)
        stateAbbr = try values.decodeIfPresent(String.self, forKey: .stateAbbr)
        lastUpdated = try values.decodeIfPresent(String.self, forKey: .lastUpdated)
    }
    
    init() {
        
    }
    
}
