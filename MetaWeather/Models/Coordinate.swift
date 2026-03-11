//
//  Coordinate.swift
//  MetaWeather
//
//  Created by DavidMartin on 6/23/22.
//

import Foundation

struct Coordinate: Decodable {
    let latitude: Float
    let longitude: Float
    let name: String
    
    // MARK: Coding Keys
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decodeIfPresent(Float.self, forKey: .latitude) ?? 0
        longitude = try values.decodeIfPresent(Float.self, forKey: .longitude) ?? 0
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
    
    init(latitude: Float, longitude: Float) {
        self.latitude = latitude
        self.longitude = longitude
        name = ""
    }
    
}
