//
//  PhotoDownloader.swift
//  MetaWeather
//
//  Created by DavidMartin on 7/14/22.
//

import Foundation
import UIKit

class PhotoDownloader: NSCopying {
    
    static let shared = PhotoDownloader()
    
    private var cachedImageUrl: URL?
    
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
    func downloadPhotoFrom(photoUrl: String, completionHandler: @escaping(UIImage) -> Void) {
        guard let url = URL(string: photoUrl) else {
            // Set placeholder image here
            if let notNilImage = UIImage(named: "placeholder") {
                completionHandler(notNilImage)
            }
            return
        }
        if url != cachedImageUrl {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    print("\n Download Photo Completed!!! \n")
                    completionHandler(image)
                }
            }
        }
        cachedImageUrl = url
    }
    
    
    
    
}
