//
//  File.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation
import UIKit

enum Constants {
    // MARK: Commons
    static let lottieFileName = "cat-loading"
    static let navigationBarHeight: CGFloat = 44
    
    // MARK: Video
    static let videoServiceToken = "API_KEY"
    static let apiGetVideo = "https://api.pexels.com/videos/popular"
  
    // MARK: Weather
    static let woeId = "1252431" // Ho Chi Minh city
    static let apiRootPath = "https://www.metaweather.com/api"
    static let apiLocation = "/location/"
    static let apiSearch = "search/"
    
    // MARK: News
    static let newsPath = "https://vnexpress.net/rss/suc-khoe.rss"
}
