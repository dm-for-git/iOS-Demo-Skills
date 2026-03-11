//
//  SquareImage.swift
//  MetaWeather
//
//  Created by DavidMartin on 3/30/22.
//

import SwiftUI

struct SquareImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: 90, height: 90, alignment: .center)
            .shadow(color: Color(UIColor.lightGray), radius: 7, x: -5, y: 5)
            .cornerRadius(20)
    }
}

struct SquareImage_Previews: PreviewProvider {
    static var previews: some View {
        SquareImage(imageName: "default_avatar")
    }
}
