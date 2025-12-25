//
//  ImageViewLoader.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/13/21.
//

import UIKit

class ImageLoaderView: UIImageView {
    
    func load(strUrl: String) {
        PhotoDownloader.shared.downloadPhotoFrom(photoUrl: strUrl) { image in
            Task { @MainActor [weak self] in
                self?.image = image
            }
        }
    }
}

