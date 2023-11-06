//
//  Onboarding.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 02.11.2023.
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

extension Onboarding: Hashable {}
extension OnboardingStep: Hashable {}
