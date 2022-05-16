//
//  NewsListView.swift
//  MetaWeather
//
//  Created by David Martin on 02/03/2022.
//

import SwiftUI

struct NewsListView: View {
    
    var arrNames = ["A List Item", "A Second List Item", "A Third List Item",
                    "A 84YN5VG84Y8T", "VW39J8YTN934N", "CP0M4FPQ3U4V09",
                    "VOQ89Y3 4O8   8I"]
    let strTime = "15 minutes ago"
    
    let columns: [GridItem] =
    Array(repeating: .init(.flexible()), count: 1)
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                colors: [.orange, .red],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            ScrollView() {
                LazyVGrid(columns: columns) {
                    ForEach(arrNames, id: \.self) { title in
                        NewsListItemView(title: title, time: strTime, image: "default_avatar")
                    }
                }
            }
        }
        
    }
    
}

struct NewsListPreView: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 15.0, *) {
                NewsListView()
                    .previewInterfaceOrientation(.portrait)
            } else {
                NewsListView()
            }
        }
    }
}
