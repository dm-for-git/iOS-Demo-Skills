//
//  HeaderView.swift
//  MetaWeather
//
//  Created by David Martin on 28/02/2022.
//

import SwiftUI


struct HeaderView: View {
    let photoName: String
    let name: String
    let position: String
    
    var body: some View {
            ZStack(alignment: .bottom) {
                Image(photoName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                HStack {
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.headline)
                        Text(position)
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding()
                .foregroundColor(.primary)
                .background(Color.primary
                                .colorInvert()
                                .opacity(0.75))
            }
        }
}
