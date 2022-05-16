//
//  LatestNewsView.swift
//  MetaWeather
//
//  Created by David Martin on 28/02/2022.
//

import SwiftUI

struct LatestNewsView: View {
    let names: [String]
    let avatars: [String]
    let positions: [String]
    
    var body: some View {
        ZStack {
            
            setupView()
        }
        
    }
    
    @ViewBuilder
    func setupView() -> some View {
        if !names.isEmpty && !avatars.isEmpty && !positions.isEmpty {
            TabView {
                ForEach((0..<names.count), id: \.self) { index in
                    HeaderView(photoName: avatars[index], name: names[index], position: positions[index])
                }
            }.tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
        } else {
            EmptyView()
        }
    }
}
