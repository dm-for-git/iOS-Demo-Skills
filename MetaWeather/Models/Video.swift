//
//  Weather.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation


struct Video: Codable {
    var videoFiles: [VideoFile]?
    var videoPictures: [VideoPicture]?
    
    enum CodingKeys: String, CodingKey {
        case videoFiles = "video_files"
        case videoPictures = "video_pictures"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        videoFiles = try values.decodeIfPresent([VideoFile].self, forKey: .videoFiles)
        videoPictures = try values.decodeIfPresent([VideoPicture].self, forKey: .videoPictures)
    }
    
}
