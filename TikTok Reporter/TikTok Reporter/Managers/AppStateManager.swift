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
    case hasAcceptedStudyTerms
    case hasCompletedOnboarding
    case hasSentOnboardingForm
}

protocol AppStateManaging {
    var study: Study? { get }
    var hasCompletedOnboarding: Bool { get }
    var hasAcceptedGeneralTerms: Bool { get }
    var hasAcceptedStudyTerms: Bool { get }
    
    func save<T: Encodable>(_ value: T, for key: AppStateKey) throws
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
    var hasAcceptedStudyTerms: Bool = false
    @Published
    var hasSentOnboardingForm: Bool = false
    
    private lazy var userDefaults = UserDefaults.standard

    // MARK: - Lifecycle

    init() {
        AppStateKey.allCases.forEach({
            switch $0 {
            case .study:
                self.study = getValue(for: .study)
            case .hasAcceptedGeneralTerms:
                self.hasAcceptedGeneralTerms = getValue(for: .hasAcceptedGeneralTerms) ?? false
            case .hasAcceptedStudyTerms:
                self.hasAcceptedStudyTerms = getValue(for: .hasAcceptedStudyTerms) ?? false
            case .hasCompletedOnboarding:
                self.hasCompletedOnboarding = getValue(for: .hasCompletedOnboarding) ?? false
            case .hasSentOnboardingForm:
                self.hasSentOnboardingForm = getValue(for: .hasSentOnboardingForm) ?? false
            }
        })
    }

    // MARK: - Methods

    func save<T: Encodable>(_ value: T, for key: AppStateKey) throws {
        let data = try JSONEncoder().encode(value)
        userDefaults.setValue(data, forKey: key.rawValue)

        // TODO: - Check if `setValue` is failable. If not, use value directly
        switch key {
        case .study:
            self.study = getValue(for: .study)
        case .hasAcceptedGeneralTerms:
            self.hasAcceptedGeneralTerms = getValue(for: .hasAcceptedGeneralTerms) ?? false
        case .hasAcceptedStudyTerms:
            self.hasAcceptedStudyTerms = getValue(for: .hasAcceptedStudyTerms) ?? false
        case .hasCompletedOnboarding:
            self.hasCompletedOnboarding = getValue(for: .hasCompletedOnboarding) ?? false
        case .hasSentOnboardingForm:
            self.hasSentOnboardingForm = getValue(for: .hasSentOnboardingForm) ?? false
        }
    }

    func clearAll() {
        AppStateKey.allCases.forEach {
            userDefaults.removeObject(forKey: $0.rawValue)
        }

        self.study = nil
        self.hasAcceptedGeneralTerms = false
        self.hasAcceptedStudyTerms = false
        self.hasCompletedOnboarding = false
    }

    // MARK: - Private Methods

    private func getValue<T: Decodable>(for key: AppStateKey) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue) else {
            return nil
        }

        return try? JSONDecoder().decode(T.self, from: data)
    }
}
