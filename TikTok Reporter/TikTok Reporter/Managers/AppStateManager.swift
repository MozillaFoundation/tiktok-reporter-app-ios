//
//  AppStateManager.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 09.11.2023.
//

import SwiftUI

enum AppStateKey: String, CaseIterable {
    case study
    case hasAcceptedGeneralTerms
    case hasCompletedOnboarding
    case emailAddress
}

final class AppStateManager: ObservableObject {
    
    // MARK: - Properties

    @Published
    var study: Study?
    @Published
    var hasCompletedOnboarding: Bool = false
    @Published
    var hasAcceptedGeneralTerms: Bool = false
    @Published
    var emailAddress: String?
    @Published
    var onboardingFlow: OnboardingFlow? = nil

    private lazy var userDefaults = UserDefaults(suiteName: Strings.appGroupID)

    // MARK: - Lifecycle

    init() {

        AppStateKey.allCases.forEach({

            switch $0 {
            case .study:
                self.study = getValue(for: .study)

            case .hasAcceptedGeneralTerms:
                self.hasAcceptedGeneralTerms = getValue(for: .hasAcceptedGeneralTerms) ?? false

            case .hasCompletedOnboarding:
                self.hasCompletedOnboarding = getValue(for: .hasCompletedOnboarding) ?? false

            case .emailAddress:
                self.emailAddress = getValue(for: .emailAddress)
            }
        })
    }

    // MARK: - CRUD

    func save<T: Encodable>(_ value: T, for key: AppStateKey) throws {

        let data = try JSONEncoder().encode(value)
        userDefaults?.setValue(data, forKey: key.rawValue)

        switch key {
        case .study:
            self.study = getValue(for: .study)

        case .hasAcceptedGeneralTerms:
            self.hasAcceptedGeneralTerms = getValue(for: .hasAcceptedGeneralTerms) ?? false

        case .hasCompletedOnboarding:
            self.hasCompletedOnboarding = getValue(for: .hasCompletedOnboarding) ?? false

        case .emailAddress:
            self.emailAddress = getValue(for: .emailAddress)
        }
    }

    func clearAll() {

        AppStateKey.allCases.forEach {
            userDefaults?.removeObject(forKey: $0.rawValue)
        }

        self.study = nil
        self.hasAcceptedGeneralTerms = false
        self.hasCompletedOnboarding = false
        self.emailAddress = nil
    }

    // MARK: - Onboarding

    func setOnboarding(with study: Study) {
        onboardingFlow = OnboardingFlow(study: study)
    }

    func updateOnboarding() {
        let isLastStep = onboardingFlow?.nextStep() == nil
        
        if isLastStep {
            try? save(true, for: .hasCompletedOnboarding)
            onboardingFlow = nil
        }
    }

    // MARK: - Private Methods

    private func getValue<T: Decodable>(for key: AppStateKey) -> T? {
        guard let data = userDefaults?.data(forKey: key.rawValue) else {
            return nil
        }

        return try? JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - Strings

private enum Strings {
    static let appGroupID = "group.org.mozilla.ios.TikTok-Reporter"
}
