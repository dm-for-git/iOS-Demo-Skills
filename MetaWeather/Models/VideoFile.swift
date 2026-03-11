//
//  Weather.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation

struct VideoFile: Codable {
    var videoId: Int?
    var quality: String?
    var link: String?
    
    enum CodingKeys: String, CodingKey {
        case videoId = "id"
        case quality
        case link
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(videoId, forKey: .videoId)
        try container.encodeIfPresent(quality, forKey: .quality)
        try container.encodeIfPresent(link, forKey: .link)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        videoId = try container.decodeIfPresent(Int.self, forKey: .videoId)
        quality = try container.decodeIfPresent(String.self, forKey: .quality)
        link = try container.decodeIfPresent(String.self, forKey: .link)
    }
    
}
