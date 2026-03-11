//
//  CircleImage.swift
//  MetaWeather
//
//  Created by David Martin on 02/03/2022.
//

import SwiftUI

struct CircleImage: View {
    var imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: 90, height: 90, alignment: .center)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .shadow(color: Color(UIColor.lightGray), radius: 7, x: -5, y: 5)
            .overlay(Circle().stroke(.white, lineWidth: 2))
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(imageName: "default_avatar")
    }
}
