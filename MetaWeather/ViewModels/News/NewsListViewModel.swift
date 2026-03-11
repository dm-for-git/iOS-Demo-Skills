//
//  NewsListViewModel.swift
//  MetaWeather
//
//  Created by David Martin on 25/02/2022.
//

import Foundation
import UIKit

class NewsListViewModel {
    lazy var arrAvatars: [String] = {
        var photos = [String]()
        for index in 1...7 {
            photos.append("p\(index)")
        }
        return photos
    }()
    
    lazy var arrNewsHeader = [NewsHeader]()
    
    lazy var arrNames: [String] = {
        return ["Tom", "Jerry", "Donald", "Mickey", "Puppy", "Kitty", "Putin"]
    }()
    
    lazy var arrPositions: [String] = {
        return ["Chief Officer Executive", "President", "Lead Engineer", "Staff Engineer", "Principal Engineer", "Architect", "Poor Man"]
    }()
    
    

    func fetchNews(handler: @escaping(Bool) -> Void) {
        if let url = URL(string: Constants.newsPath) {
            let xmlParser = XmlParser()
            xmlParser.setup(url: url)
            xmlParser.startParsing()
            xmlParser.completionHandler = {[weak self] result in
                self?.arrNewsHeader = result
                handler(true)
            }
        }
    }
    
}
