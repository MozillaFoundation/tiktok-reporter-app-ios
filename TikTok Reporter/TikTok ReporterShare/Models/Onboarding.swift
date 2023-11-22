//
//  Onboarding.swift
//  TikTok ReporterShare
//
//  Created by Sergiu Ghiran on 21.11.2023.
//

import Foundation

struct Onboarding: Codable {
    let id: String
    let name: String
    let steps: [OnboardingStep]
    let form: Form?
}

struct OnboardingStep: Codable {
    let id: String
    let title: String
    let subtitle: String
    let description: String
    let imageUrl: String
    let details: String?
    let order: Int
    let onboardings: [String]
}

extension OnboardingStep: Hashable {}
extension Onboarding: Hashable {}

