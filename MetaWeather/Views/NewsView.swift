//
//  NewsListView.swift
//  MetaWeather
//
//  Created by David Martin on 25/02/2022.
//

import SwiftUI

struct NewsView: View {
    
    let viewModel = NewsListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("#EFFAFD").ignoresSafeArea()
                VStack{
                    LatestNewsView(names: viewModel.arrNames, avatars: viewModel.arrAvatars, positions: viewModel.arrPositions)
                        .aspectRatio(3/2, contentMode: .fit)
                        .listRowInsets(EdgeInsets())
                    
                    NewsListView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                    .navigationTitle("Latest News")
            }
        }
    }
    
}

struct NewsPreview: PreviewProvider {
    static var previews: some View {
        Group {
            NewsView()
        }
    }
}
