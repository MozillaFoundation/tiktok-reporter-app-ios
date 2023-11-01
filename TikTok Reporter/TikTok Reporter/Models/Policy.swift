//
//  Policy.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
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
