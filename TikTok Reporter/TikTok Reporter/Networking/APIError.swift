//
//  APIError.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
//

import Foundation

enum APIError: Error {
    case decodingError
    case badRequest
    case invalidURL
}
