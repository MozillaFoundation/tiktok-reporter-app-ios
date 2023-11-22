//
//  Policy.swift
//  TikTok ReporterShare
//
//  Created by Sergiu Ghiran on 21.11.2023.
//

import Foundation

enum PolicyType: String, Codable {
    case termsOfService = "TermsOfService"
    case privacyPolicy = "PrivacyPolicy"
}

struct Policy: Codable {
    let id: String
    let type: PolicyType
    let title: String
    let subtitle: String
    let text: String
    let studies: [String]
}

extension Policy: Hashable {}

