//
//  Weather.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation

struct Page: Codable {
    var currentPage: Int?
    var nextPage: String?
    
    var videos: [Video]?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case nextPage = "next_page"
        case videos
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(currentPage, forKey: .currentPage)
        try container.encodeIfPresent(nextPage, forKey: .nextPage)
        try container.encodeIfPresent(videos, forKey: .videos)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        videos = try values.decodeIfPresent([Video].self, forKey: .videos)
        currentPage = try values.decodeIfPresent(Int.self, forKey: .currentPage)
        nextPage = try values.decodeIfPresent(String.self, forKey: .nextPage)
    }
    
}
