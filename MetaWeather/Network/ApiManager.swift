//
//  ApiManager.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation
import Network


final class ApiManager: NSCopying, Sendable {
    
    // Prevent instance of this object to be cloned
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
    static let shared = ApiManager()
    private var dataTask: URLSessionDataTask?
    
    private lazy var defaultSession: URLSession = {
        let config = URLSessionConfiguration.default
        // Set timeout in second
        config.timeoutIntervalForResource = 20
        config.timeoutIntervalForRequest = 20
        
        config.waitsForConnectivity = true
        
        let session = URLSession(configuration: config)
        
        return session
    }()
    
    // MARK: GET
    func getRequest(url: String, withBearer: Bool? = false, params: [String: String]) async -> Result<Data, CustomError>? {
        var result : Result<Data, CustomError>?
        dataTask?.cancel()
      
        if var urlComponents = URLComponents(string: url) {
            if !params.isEmpty {
                urlComponents.queryItems = createQueryParamFrom(params: params)
            }
            guard let url = urlComponents.url else {
                return .failure(.invalidUrl)
            }
            
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
            request.httpMethod = "GET"
            if let isUsingBearer = withBearer, isUsingBearer == true {
                guard videoServiceToken != "" else {
                    return .failure(.tokenMissing)
                }
                request.setValue(videoServiceToken, forHTTPHeaderField: "Authorization")
            }
            
            Task {
            await dataTask = defaultSession.dataTask(with: request,
                                                         completionHandler: {[weak self] data, response, error in
                    defer {
                        self?.dataTask = nil
                    }
                    if let customError = error as? CustomError {
                        print("GET request error = \(customError.localizedDescription)")
                        result = .failure(customError)
                    } else if let networkError = error as? URLError {
                        print("Network error = \(networkError.localizedDescription)")
                        result = .failure(.networkError)
                    } else if let response = response as? HTTPURLResponse,
                              response.statusCode <= 300 {
                        if let data = data {
                            result = .success(data)
                        }
                    } else {
                        // This is where the HTTP Status Code > 300
                        result = .failure(.serverError)
                    }
                })
                dataTask?.resume()
            }
        }
        return result
    }
    
    // MARK: POST
    func postRequest(url: String, params: [String: String],
                     completion: @escaping(Result<Data, CustomError>) -> Void) {
        dataTask?.cancel()
        if let urlComponents = URLComponents(string: url) {
            guard let url = urlComponents.url else {
                completion(.failure(.invalidUrl))
                return
            }
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            if !params.isEmpty {
                do {
                    // Create body
                    request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                } catch {
                    completion(.failure(error as! CustomError))
                }
            }
            
            dataTask = defaultSession.dataTask(with: request, completionHandler: {[weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                if let err = error as? CustomError {
                    print("POST request error = \(err.localizedDescription)")
                    completion(.failure(err))
                } else if let networkError = error as? URLError {
                    print("Network error = \(networkError.localizedDescription)")
                    completion(.failure(.networkError))
                } else if let data = data {
                    completion(.success(data))
                }
            })
            dataTask?.resume()
        }
    }
    
    // MARK: Downloading
    /**
     Remember to add these keys into Infor.plist file in order to allow users
     can access downloaded files via the File app of iOS
     Application supports iTunes file sharing
     * UIFileSharingEnabled = YES
     * LSSupportsOpeningDocumentsInPlace = YES
     */
    func downloadFromUrl(link: String, completionHandler: @escaping(Result<String, CustomError>) -> Void) {
        if let url = URL(string: link) {
            let downloadTask = defaultSession.downloadTask(with: url, completionHandler: {[weak self] urlOrNil, responseOrNil, errorOrNil in
                if let customError = errorOrNil as? CustomError {
                    print("Downloading error = \(customError.localizedDescription)")
                    completionHandler(.failure(customError))
                }
                if let fileURL = urlOrNil {
                    do {
                        let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                                       in: .userDomainMask,
                                                                       appropriateFor: nil,
                                                                       create: true)
                        let dataUrl = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
                        try FileManager.default.copyItem(at: fileURL, to: dataUrl)
                        let fileData = try Data(contentsOf: dataUrl)
                        let fileName = documentsURL.path + (self?.lastComponentFrom(link: link) ?? "")
                        FileManager.default.createFile(atPath: fileName, contents: fileData)
                        completionHandler(.success(fileName))
                    } catch {
                        print("File error = \(error.localizedDescription)")
                        if let customErr = error as? CustomError {
                            completionHandler(.failure(customErr))
                        }
                    }
                }
            })
            downloadTask.resume()
        }
    }
    
    private func lastComponentFrom(link: String) -> String {
        guard let index = link.lastIndex(of: "/") else { return "" }
        
        return String(link.suffix(from: index))
    }
    
    // MARK: Utilities
    private func createQueryParamFrom(params: [String: String]) -> [URLQueryItem] {
        var result = [URLQueryItem]()
        for param in params {
            result.append(URLQueryItem(name: param.key, value: param.value))
        }
        return result
    }
    
    private var videoServiceToken: String {
        if let apiKey = Bundle.main.infoDictionary?[Constants.videoServiceToken] as? String {
            return apiKey
        }
        print("\n Video Service Token is missing \n")
        return ""
    }
    
    static var weatherServiceApiKey: String {
        if let apiKey = Bundle.main.infoDictionary?[Constants.weatherApiKey] as? String {
            return apiKey
        }
        print("\n Weather Service Token is missing \n")
        return ""
    }
}
