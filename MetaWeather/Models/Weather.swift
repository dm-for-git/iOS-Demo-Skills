//
//  Weather.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation

/**
 * To get weather status icon by weather status code
 https://openweathermap.org/img/wn/03n@2x.png
 */
/**
 
 */


struct Weather: Decodable {
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
        case status = "description"
        case iconCode = "icon"
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
        
        
        let weatherContainer = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .weather)
        status = try weatherContainer.decodeIfPresent(String.self, forKey: .status)
        iconCode = try weatherContainer.decodeIfPresent(String.self, forKey: .iconCode)
    }
    
    init() {
        
    }
    
}
