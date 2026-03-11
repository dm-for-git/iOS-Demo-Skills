//
//  XmlParser.swift
//  MetaWeather
//
//  Created by David Martin on 25/02/2022.
//

import Foundation

class XmlParser: NSObject {
    var url: URL?
    var xmlParser: XMLParser?
    
    private lazy var arrNewsHeader = {
        return [NewsHeader]()
    }()
    
    var completionHandler: ([NewsHeader]) -> Void = {_ in }
    
    var newsHeader: NewsHeader!
    
    func setup(url: URL?) {
        if let url = url {
            xmlParser = XMLParser(contentsOf: url)
        } else {
            print("The XML url is invalid!!!")
        }
    }
    
    func startParsing() {
        if let xmlParser = xmlParser {
            xmlParser.parse()
            xmlParser.delegate = self
        }
    }
}

extension XmlParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
            // Start of a newsHeader object
        case XmlKeys.item.rawValue:
            newsHeader = NewsHeader()
        case XmlKeys.image.rawValue:
            newsHeader.coverUrl = attributeDict[XmlKeys.source.rawValue] ?? ""
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
            // End of a newsHeader object then add it into the news list
        case  XmlKeys.item.rawValue:
            arrNewsHeader.append(newsHeader)
        case XmlKeys.rss.rawValue:
            // Finished parsing
            completionHandler(arrNewsHeader)
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let strData = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !strData.isEmpty {
            switch strData {
            case XmlKeys.title.rawValue:
                newsHeader.title = strData
            case XmlKeys.pubDate.rawValue:
                newsHeader.pubDate = strData
            case XmlKeys.link.rawValue:
                newsHeader.detailUrl = strData
            default:
                break
            }
        }
    }
}
