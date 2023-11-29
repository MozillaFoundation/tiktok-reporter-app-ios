//
//  StudiesAPI.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 02.11.2023.
//

import Foundation

enum StudiesAPI: APIRequest {
    case getStudies

    var method: APIMethod {
        switch self {
        case .getStudies:
            return .GET
        }
    }

    var path: String {
        switch self {
        case .getStudies:
            return "studies/by-country-code"
        }
    }

    var body: [String : Any]? {
        switch self {
        case .getStudies:
            return nil
        }
    }
}
