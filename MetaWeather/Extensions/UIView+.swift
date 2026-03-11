//
//  UIViewExtension.swift
//  MetaWeather
//
//  Created by DavidMartin on 9/4/21.
//

import Foundation
import UIKit
import Lottie

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        layer.masksToBounds = true
    }
}

