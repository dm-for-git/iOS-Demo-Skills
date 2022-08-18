//
//  VideoViewModel.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/13/21.
//

import Foundation

final class VideoViewModel {
    lazy var apiManager: ApiManager = {
        return ApiManager.shared
    }()
    
    var nextPage = ""
    
    var arrThumbnails: [(imgUrl: String?, videoUrl: String?)] = []
    
    var currentVideoUrl = ""
    
    var isLoadingData = false
    // For efficient reload data
    var lastPreviousIndex = 0
    
    func fetchMoreData(handler: @escaping(Bool) -> Void) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        
        queue.addOperation {[unowned self] in
            var parameters: [String: String] = [:]
            var url = Constants.apiGetVideo
            if nextPage == "" {
                parameters = ["per_page": "10"]
            } else {
                url = nextPage
            }
            
            apiManager.getRequest(url: url, withBearer: true, params: parameters) {[weak self] result in
                switch result {
                case .success(let notNilData):
                    let decoder = JSONDecoder()
                    do {
                        let videos = try decoder.decode(Page.self, from: notNilData)
                        queue.addOperation {
                            self?.exactNestedDataFrom(data: videos) { isSuccess in
                                handler(isSuccess)
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                        handler(false)
                    }
                case .failure(let error):
                    print(error.description)
                    handler(false)
                }
                
            }
        }
        queue.waitUntilAllOperationsAreFinished()
    }
    
    private func exactNestedDataFrom(data: Page, finish: @escaping(Bool) -> Void) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        
        queue.addOperation {[unowned self] in
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
            
            finish(true)
        }
        queue.waitUntilAllOperationsAreFinished()
    }
    
    func downloadGifFrom(link: String) {
        // https://i.imgur.com/q3e87zR.gif
        apiManager.downloadFromUrl(link: link) { [weak self] result in
            switch result {
            case .success(let path):
                print("File was downloaded at = \(path)")
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
}
