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
    
    // MARK: Video
    static let videoServiceToken = "PEXEL_API_KEY"
    static let apiGetVideo = "https://api.pexels.com/videos/popular"
  
    // MARK: Weather
    static let weatherApiKey = "WEATHER_API_KEY"
    // Ho Chi Minh city's coordinate
    static let hcmCoordinate: (Float, Float) = (10.7758439, 106.7017555)
    
    static let apiRootPath = "https://api.openweathermap.org/"
    static let apiWeather = "data/3.0/onecall"
    static let apiLocation = "geo/1.0/direct"
    
    static let apiIcon = "https://openweathermap.org/img/wn/"
    
    // MARK: News
    static let newsPath = "https://vnexpress.net/rss/suc-khoe.rss"
}
