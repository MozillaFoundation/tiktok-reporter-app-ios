//
//  Study.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 02.11.2023.
//

import Foundation

struct Study: Codable {
    let id: String
    let name: String
    let description: String
    let isActive: Bool
    let supportsRecording: Bool
    let countryCodes: [String]
    let policies: [Policy]
    let onboarding: Onboarding?
    let form: Form?
}

extension Study: Hashable {}
