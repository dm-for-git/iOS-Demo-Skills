//
//  ApiManager.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation
import Network


class ApiManager: NSCopying {
    
    // Prevent instance of this object to be cloned
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
    static let shared = ApiManager()
    private var dataTask: URLSessionDataTask?
    
    private lazy var defaultSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        // Set timeout in second
        config.timeoutIntervalForResource = 10
        config.timeoutIntervalForRequest = 10
        
        let session = URLSession(configuration: config)
        
        return session
    }()
    
    // MARK: GET
    func getRequest(url: String, withBearer: Bool? = false, params: [String: String],
                    completion: @escaping(Result<Data, CustomError>) -> Void) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: url) {
            if !params.isEmpty {
                urlComponents.queryItems = createQueryParamFrom(params: params)
            }
            guard let url = urlComponents.url else {
                completion(.failure(.invalidUrl))
                return
            }
            
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
            request.httpMethod = "GET"
            if let isUsingBearer = withBearer, isUsingBearer == true {
                let bearer = "Bearer \(videoServiceToken)"
                request.setValue(bearer, forHTTPHeaderField: "Authorization")
            }
            
            dataTask = defaultSession.dataTask(with: request, completionHandler: {  [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                if let err = error as? CustomError {
                    print("GET request error = \(err.localizedDescription)")
                    completion(.failure(err))
                } else if let networkError = error as? URLError {
                    print("Network error = \(networkError.localizedDescription)")
                    completion(.failure(.networkError))
                } else if let data = data {
                    // let response = response as? HTTPURLResponse
                    completion(.success(data))
                }
            })
            dataTask?.resume()
        }
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
