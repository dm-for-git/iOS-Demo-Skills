//
//  PhotoDownloader.swift
//  MetaWeather
//
//  Created by DavidMartin on 7/14/22.
//

import Foundation
import UIKit

actor PhotoDownloader: Sendable {
    
    static let shared = PhotoDownloader()
    private init() {}

    private var cachedImageUrl: URL?
    
    func downloadPhotoFrom(photoUrl: String, completionHandler: @escaping @Sendable (UIImage) -> Void) {
        guard let url = URL(string: photoUrl) else {
            // Set placeholder image here
            if let notNilImage = UIImage(named: "placeholder") {
                Task { @MainActor in
                    completionHandler(notNilImage)
                }
            }
            return
        }

        var shouldDownload = false
        if url != cachedImageUrl {
            cachedImageUrl = url
            shouldDownload = true
        }

        guard shouldDownload else { return }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                Task { @MainActor in
                    completionHandler(image)
                }
            }
        }
    }
    
}
