//
//  VideoViewModel.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/13/21.
//

import Foundation
import Synchronization

typealias TaskCompletion = @Sendable (String) -> Void
typealias Thumbnail = (imgUrl: String?, videoUrl: String?)

final class VideoViewModel: Sendable {
    private let apiManager = ApiManager.shared
    
    private let _nextPage = Mutex("")
    private let _arrThumbnails = Mutex([Thumbnail]())
    private let _currentVideoUrl = Mutex("")
    private let _isLoadingData = Mutex(false)
    private let _lastPreviousIndex = Mutex(0)
    
    var nextPage: String {
        get { _nextPage.withLock { $0 } }
        set { _nextPage.withLock { $0 = newValue } }
    }
    
    var arrThumbnails: [Thumbnail] {
        get { _arrThumbnails.withLock { $0 } }
        set { _arrThumbnails.withLock { $0 = newValue } }
    }
    
    var currentVideoUrl: String {
        get { _currentVideoUrl.withLock { $0 } }
        set { _currentVideoUrl.withLock { $0 = newValue } }
    }
    
    var isLoadingData: Bool {
        get { _isLoadingData.withLock { $0 } }
        set { _isLoadingData.withLock { $0 = newValue } }
    }
    
    var lastPreviousIndex: Int {
        get { _lastPreviousIndex.withLock { $0 } }
        set { _lastPreviousIndex.withLock { $0 = newValue } }
    }
    
    func updateLoadingData(_ isLoading: Bool) {
        self.isLoadingData = isLoading
    }
    
    func fetchMoreData() async -> String {
        let result = await Task {[weak self] in
            var finalResult: String = ""
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
                    let page = try decoder.decode(Page.self, from: notNilData)
                    finalResult = await self?.exactNestedDataFrom(data: page) ?? ""
                } catch {
                    print(error.localizedDescription)
                    finalResult = error.localizedDescription
                }
            case .failure(let error):
                print(error.localizedDescription)
                finalResult = error.localizedDescription
            case .none:
                break
            }
            return finalResult
        }.result
        
        return result.get()
    }
    
    private func exactNestedDataFrom(data: Page) async -> String {
        let extractedData = await Task {
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
            
            return ""
        }.result
        return extractedData.get()
    }
}
