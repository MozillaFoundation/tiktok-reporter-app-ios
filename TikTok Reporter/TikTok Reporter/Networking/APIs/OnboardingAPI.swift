//
//  OnboardingAPI.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 04.11.2023.
//

import Foundation

enum OnboardingAPI: APIRequest {
    case getOnboarding(id: String)

    var method: APIMethod {
        switch self {
        case .getOnboarding:
            return .GET
        }
    }

    var path: String {
        switch self {
        case let .getOnboarding(id):
            return "onboarding/".appending(id)
        }
    }

    var body: [String : Any]? {
        switch self {
        case .getOnboarding:
            return nil
        }
    }
}
