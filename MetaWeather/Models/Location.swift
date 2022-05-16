//
//  Location.swift
//  MetaWeather
//
//  Created by David Martin on 26/01/2022.
//

import Foundation

struct Location: Codable {
    /**
     {
             "title": "San Francisco",
             "location_type": "City",
             "woeid": 2487956,
             "latt_long": "37.777119, -122.41964"
         }
     */
    let title: String
    let woeid: Int
    
}
