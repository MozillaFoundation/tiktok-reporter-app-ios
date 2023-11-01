//
//  PoliciesAPI.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
//

import Foundation

enum PoliciesAPI: APIRequest {
    case getAppPolicies

    var method: APIMethod {
        switch self {
        case .getAppPolicies:
            return .GET
        }
    }

    var path: String {
        switch self {
        case .getAppPolicies:
            return "policies"
        }
    }

    var body: [String : Any]? {
        switch self {
        case .getAppPolicies:
            return nil
        }
    }
}
