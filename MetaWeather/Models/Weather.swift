//
//  Weather.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation

/**
 * To get weather status icon by weather status code
 https://openweathermap.org/img/wn/{weather status code}@2x.png
 */

/**
 {
     "coord": {
         "lon": 106.7018,
         "lat": 10.7758
     },
     "weather": [
         {
             "id": 500,
             "main": "Rain",
             "description": "light rain",
             "icon": "10n"
         }
     ],
     "base": "stations",
     "main": {
         "temp": 25.95,
         "feels_like": 25.95,
         "temp_min": 25.95,
         "temp_max": 25.95,
         "pressure": 1008,
         "humidity": 89
     },
     "visibility": 8000,
     "wind": {
         "speed": 3.09,
         "deg": 180
     },
     "rain": {
         "1h": 0.22
     },
     "clouds": {
         "all": 40
     },
     "dt": 1654795281,
     "sys": {
         "type": 1,
         "id": 9314,
         "country": "VN",
         "sunrise": 1654813827,
         "sunset": 1654859692
     },
     "timezone": 25200,
     "id": 1566083,
     "name": "Ho Chi Minh City",
     "cod": 200
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
