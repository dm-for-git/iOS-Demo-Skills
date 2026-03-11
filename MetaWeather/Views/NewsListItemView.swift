//
//  NewsListItemView.swift
//  MetaWeather
//
//  Created by David Martin on 02/03/2022.
//

import SwiftUI

struct NewsListItemView: View {
    let title: String
    let time: String
    let image: String
    
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.headline)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .padding([.top, .bottom, .trailing], 10)
                    
                    HStack {
                        Text(time)
                            .foregroundColor(.white)
                            .font(.footnote)
                            .padding([.bottom, .trailing], 10)
                        
                        Button(action: {
                        }) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                        }.padding([.bottom], 10)
                        
                        Spacer()
                    }
                }.padding([.leading], 90)
                
            }.background(Color("#2F3132").ignoresSafeArea())
                .cornerRadius(10, corners: [.bottomLeft])
                .padding([.leading], 30)
                .padding([.top, .bottom], 20)
            
            SquareImage(imageName: image).offset(x: -150, y: -15)
            
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

struct NewsListItemPreView: PreviewProvider {
    static var previews: some View {
        NewsListItemView(title: "This is a very long and big title if you can't see these lines, that's because they're too long", time: "15 minutes ago", image: "default_avatar")
    }
}

