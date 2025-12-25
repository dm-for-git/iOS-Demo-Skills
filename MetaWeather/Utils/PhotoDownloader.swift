//
//  PhotoDownloader.swift
//  MetaWeather
//
//  Created by DavidMartin on 7/14/22.
//

import Foundation
import UIKit

final class PhotoDownloader: NSCopying, Sendable {
    
    static let shared = PhotoDownloader()
    private init() {}

    private var cachedImageUrl: URL?
    private let lock = NSLock()
    
    // Prevent instance of this object to be cloned because this class serves as a Singleton
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
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
        lock.lock()
        if url != cachedImageUrl {
            cachedImageUrl = url
            shouldDownload = true
        }
        lock.unlock()

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
