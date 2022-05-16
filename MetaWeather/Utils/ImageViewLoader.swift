//
//  ImageViewLoader.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/13/21.
//

import UIKit

class ImageViewLoader: UIImageView {
    
    private var cachedImageUrl: URL?
    
    func load(strUrl: String) {
        guard let url = URL(string: strUrl) else {
            // Set placeholder image here
            DispatchQueue.main.async {[weak self] in
                self?.image = UIImage(named: "placeholder")
            }
            return
        }
        if url != cachedImageUrl {
            DispatchQueue.global().async {[weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }
        cachedImageUrl = url
    }
}

