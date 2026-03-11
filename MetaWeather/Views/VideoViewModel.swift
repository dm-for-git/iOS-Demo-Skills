//
//  VideoViewModel.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/13/21.
//

import Foundation

typealias TaskCompletion = @Sendable (String) -> Void

final class VideoViewModel: Sendable {
    
    
    
    lazy var apiManager: ApiManager = {
        return ApiManager.shared
    }()
    
    var nextPage = ""
    
    var arrThumbnails: [(imgUrl: String?, videoUrl: String?)] = []
    
    var currentVideoUrl = ""
    
    var isLoadingData = false
    // For efficient reload data
    var lastPreviousIndex = 0
    
    func fetchMoreData(handler: @escaping TaskCompletion) async {
        Task {[weak self] in
            var parameters: [String: String] = [:]
            var url = Constants.apiGetVideo
            if self?.nextPage == "" {
                parameters = ["per_page": "10"]
            } else {
                url = self?.nextPage ?? ""
            }
            
            let result = await self?.apiManager.getRequest(url: url, params: parameters)
            switch result {
            case .success(let notNilData):
                let decoder = JSONDecoder()
                do {
                    let videos = try decoder.decode(Page.self, from: notNilData)
                    await self?.exactNestedDataFrom(data: videos) { isSuccess in
                        handler(isSuccess)
                    }
                } catch {
                    print(error.localizedDescription)
                    handler(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                handler(error.localizedDescription)
            case .none:
                break
            }
        }
        
        
    }
    
    private func exactNestedDataFrom(data: Page, finish: @escaping TaskCompletion) async {
        Task {
            for video in data.videos ?? [] {
                var fileUrl = ""
                var pictureUrl = ""
                if let videoFiles = video.videoFiles {
                    for file in videoFiles {
                        fileUrl = file.link ?? ""
                        break
                    }
                }
                if let videoPitures = video.videoPictures {
                    for picture in videoPitures {
                        pictureUrl = picture.pictureUrl ?? ""
                        break
                    }
                }
                arrThumbnails.append((pictureUrl, fileUrl))
            }
            // Set the next page need to be called when the the user scroll down to the end of the screen
            nextPage = data.nextPage ?? ""
            
            finish("")
        }
        
        
        
    }
}
