//
//  StudiesAPI.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 02.11.2023.
//

import Foundation

enum StudiesAPI: APIRequest {
    case getStudies
    case getOnboarding(id: String)

    var method: APIMethod {
        switch self {
        case .getStudies:
            return .GET
        case .getOnboarding:
            return .GET
        }
    }

    var path: String {
        switch self {
        case .getStudies:
            return "studies/by-country-code"
        case let .getOnboarding(id):
            return "onboarding/".appending(id)
        }
    }

    var body: [String : Any]? {
        switch self {
        case .getStudies:
            return nil
        case .getOnboarding:
            return nil
        }
    }
}
