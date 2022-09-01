//
//  Weather.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation

struct VideoPicture: Codable {
    var pictureId: Int?
    var pictureUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case pictureId = "id"
        case pictureUrl = "picture"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(pictureId, forKey: .pictureId)
        try container.encodeIfPresent(pictureUrl, forKey: .pictureUrl)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pictureId = try values.decodeIfPresent(Int.self, forKey: .pictureId)
        pictureUrl = try values.decodeIfPresent(String.self, forKey: .pictureUrl)
    }
}
