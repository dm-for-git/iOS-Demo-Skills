//
//  UIDevice+.swift
//  MetaWeather
//
//  Created by DavidMartin on 02/05/2022.
//

import Foundation
import UIKit

extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        guard let window = windowScenes?.windows.first else { return false }

        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 30
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
