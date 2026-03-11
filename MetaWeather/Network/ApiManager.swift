//
//  ApiManager.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import Foundation
import Network


actor ApiManager: Sendable {
    
    // To prevent this class be initialized from outside
    private init() {}
    
    static let shared = ApiManager()
    
    private lazy var defaultSession: URLSession = {
        let config = URLSessionConfiguration.default
        // Set timeout in second
        config.timeoutIntervalForResource = 10
        config.timeoutIntervalForRequest = 10
        
        config.waitsForConnectivity = true
        
        let session = URLSession(configuration: config)
        
        return session
    }()
    
    // MARK: GET
    func getRequest(url: String, withBearer: Bool? = false, params: [String: String]) async -> Result<Data, CustomError> {
        guard var urlComponents = URLComponents(string: url) else {
            return .failure(.invalidUrl)
        }
        if !params.isEmpty {
            urlComponents.queryItems = createQueryParamFrom(params: params)
        }
        guard let finalURL = urlComponents.url else {
            return .failure(.invalidUrl)
        }

        var request = URLRequest(url: finalURL, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = "GET"
        if let isUsingBearer = withBearer, isUsingBearer == true {
            guard videoServiceToken != "" else {
                return .failure(.tokenMissing)
            }
            request.setValue(videoServiceToken, forHTTPHeaderField: "Authorization")
        }

        do {
            let (data, response) = try await defaultSession.data(for: request)
            if let http = response as? HTTPURLResponse, http.statusCode <= 300 {
                return .success(data)
            } else {
                return .failure(.serverError)
            }
        } catch let urlError as URLError {
            print("Network error = \(urlError.localizedDescription)")
            return .failure(.networkError)
        } catch {
            return .failure(.fileError)
        }
    }
    
    // MARK: POST
    func postRequest(url: String, params: [String: String]) async -> Result<Data, CustomError> {
        guard let urlComponents = URLComponents(string: url), let finalURL = urlComponents.url else {
            return .failure(.invalidUrl)
        }

        var request = URLRequest(url: finalURL, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        if !params.isEmpty {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                return .failure(.fileError)
            }
        }

        do {
            let (data, response) = try await defaultSession.data(for: request)
            if let http = response as? HTTPURLResponse, http.statusCode <= 300 {
                return .success(data)
            } else {
                return .failure(.serverError)
            }
        } catch let urlError as URLError {
            print("Network error = \(urlError.localizedDescription)")
            return .failure(.networkError)
        } catch {
            return .failure(.fileError)
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
    func downloadFromUrl(link: String) async -> Result<String, CustomError> {
        guard let url = URL(string: link) else {
            return .failure(.invalidUrl)
        }

        let request = URLRequest(url: url)

        do {
            let (tempURL, _) = try await defaultSession.download(for: request)
            do {
                let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                               in: .userDomainMask,
                                                               appropriateFor: nil,
                                                               create: true)
                let dataUrl = documentsURL.appendingPathComponent(tempURL.lastPathComponent)
                // Remove any existing file at destination to avoid copy errors
                try? FileManager.default.removeItem(at: dataUrl)
                try FileManager.default.copyItem(at: tempURL, to: dataUrl)
                let fileData = try Data(contentsOf: dataUrl)
                let fileName = documentsURL.path + self.lastComponentFrom(link: link)
                FileManager.default.createFile(atPath: fileName, contents: fileData)
                return .success(fileName)
            } catch {
                print("File error = \(error.localizedDescription)")
                return .failure(.fileError)
            }
        } catch let urlError as URLError {
            print("Network error = \(urlError.localizedDescription)")
            return .failure(.networkError)
        } catch {
            return .failure(.fileError)
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

// MARK: - Custom Error
enum CustomError: Error, CustomStringConvertible, Sendable {
    case invalidUrl
    case networkError
    case fileError
    case tokenMissing
    case serverError
    case nilError
    
    var description: String {
        switch self {
        case .invalidUrl:
            return "The URL is incorrect!!!"
        case .fileError:
            return "An error has been occurred"
        case .networkError:
            return "Your internet connection has problem"
        case .tokenMissing:
            return "Service token is missing"
        case .serverError:
            return "Server is temporary unavailable now"
        case .nilError:
            return "You're trying to access a NIL value!!!"
        }
    }
}

