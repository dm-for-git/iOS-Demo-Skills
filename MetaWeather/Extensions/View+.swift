//
//  View+.swift
//  MetaWeather
//
//  Created by David Martin on 28/02/2022.
//

import SwiftUI

extension View {
    
    func border(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeView(width: width, edges: edges).foregroundColor(color))
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
            clipShape(RoundedCorner(radius: radius, corners: corners))
        }
    
}
