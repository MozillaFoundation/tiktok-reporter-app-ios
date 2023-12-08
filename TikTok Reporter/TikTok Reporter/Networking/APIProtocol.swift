//
//  APIProtocol.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
//

import Foundation

enum Constants {
    enum URL {
        static let baseURL: String = "https://tiktok-reporter-app-be-jbrlktowcq-ew.a.run.app/"
    }
}

enum APIMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

protocol APIRequest {
    var method: APIMethod { get }
    var path: String { get }

    var body: Data? { get }
    var headers: [String: String]? { get }

    func asURLRequest() throws -> URLRequest
}

extension APIRequest {

    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: Constants.URL.baseURL.appending(path)) else {
            throw APIError.invalidURL
        }

        var urlRequest = URLRequest(url: url)

        if let headers {
            headers.forEach { (key, value) in
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData

        urlRequest.httpBody = body

        return urlRequest
    }
}

