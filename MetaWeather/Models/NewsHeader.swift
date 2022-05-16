//
//  NewsHeader.swift
//  MetaWeather
//
//  Created by David Martin on 25/02/2022.
//

import Foundation

struct NewsHeader {
    var title: String = ""
    var coverUrl: String = ""
    var pubDate: String = ""
    var detailUrl: String = ""
}

// MARK: Data Keys
enum XmlKeys: String {
    case item = "item"
    case title = "title"
    case description = "description"
    case image = "img"
    case pubDate = "pubDate"
    case link = "link"
    case source = "src"
    case rss = "rss"
}
