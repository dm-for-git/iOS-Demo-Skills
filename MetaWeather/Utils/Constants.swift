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
    // Ho Chi Minh city's coordinate
    static let hcmCoordinate: (Float, Float) = (10.7758439, 106.7017555)
    /**
     https://api.openweathermap.org/data/2.5/weather?lat=10.7758439&lon=106.7017555&appid=bb587f64faaba88b43cc87e8141cc000&units=metric
     */
    /**
     https://api.openweathermap.org/geo/1.0/direct?q=Ho Chi Minh&limit=1&appid=bb587f64faaba88b43cc87e8141cc000
     */
    
    static let apiRootPath = "https://api.openweathermap.org/"
    static let apiLocation = "geo/1.0/direct"
    static let apiSearch = "data/2.5/weather"
    
    // MARK: News
    static let newsPath = "https://vnexpress.net/rss/suc-khoe.rss"
}
