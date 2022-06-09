//
//  Location.swift
//  MetaWeather
//
//  Created by David Martin on 26/01/2022.
//

import Foundation

struct Location: Codable {
    /**
     [
         {
             "name": "Ho Chi Minh City",
             "local_names": {
                 "vi": "Thành phố Hồ Chí Minh",
                 "de": "Ho-Chi-Minh-Stadt",
                 "oc": "Hô Chi Minh Vila",
                 "lv": "Hočimina",
                 "en": "Ho Chi Minh City",
                 "nl": "Ho Chi Minhstad",
                 "fr": "Hô Chi Minh-Ville",
                 "it": "Ho Chi Minh",
                 "cs": "Ho Či Minovo Město",
                 "ru": "Хошимин",
                 "he": "הו צ'י מין סיטי",
                 "el": "Χο Τσι Μιν",
                 "feature_name": "Ho Chi Minh",
                 "ms": "Bandaraya Ho Chi Minh",
                 "km": "ទីក្រុង​ហូ​ជី​មិញ",
                 "zh": "胡志明市",
                 "et": "Hồ Chí Minh",
                 "id": "Kota Ho Chi Minh",
                 "ja": "ホーチミン市",
                 "ascii": "Ho Chi Minh",
                 "ko": "호찌민",
                 "fa": "هوشی‌مین",
                 "ar": "مدينة هو تشي منه"
             },
             "lat": 10.7758439,
             "lon": 106.7017555,
             "country": "VN"
         }
     ]
     */
    let title: String
    let woeid: Int
    
}
