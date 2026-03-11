//
//  ImageViewLoader.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/13/21.
//

import UIKit

class ImageLoaderView: UIImageView {
    
    func load(strUrl: String) {
        Task { [strUrl] in
            await PhotoDownloader.shared.downloadPhotoFrom(photoUrl: strUrl) { [weak self] image in
                Task { @MainActor in
                    self?.image = image
                }
            }
        }
    }
}

