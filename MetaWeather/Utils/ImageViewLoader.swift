//
//  ImageViewLoader.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/13/21.
//

import UIKit

class ImageViewLoader: UIImageView {
    
    func load(strUrl: String) {
        PhotoDownloader.shared.downloadPhotoFrom(photoUrl: strUrl) { image in
            DispatchQueue.main.async {[weak self] in
                self?.image = image
            }
        }
    }
}

