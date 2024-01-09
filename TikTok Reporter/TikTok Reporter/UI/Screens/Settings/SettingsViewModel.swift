//
//  SettingsViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 14.11.2023.
//

import SwiftUI

extension SettingsView {

    // MARK: - ViewModel

    final class ViewModel: ObservableObject {

        // MARK: - Properties

        private(set) var appState: AppStateManager

        var termsAndConditions: Policy?
        var privacyPolicy: Policy?
        var study: Study?
        var onboardingForm: Form?
        var emailAddress: String?

        // MARK: - Lifecycle

        init(appState: AppStateManager) {
            self.appState = appState

            self.termsAndConditions = appState.study?.policies.first(where: { $0.type == .termsOfService })
            self.privacyPolicy = appState.study?.policies.first(where: { $0.type == .privacyPolicy })
            self.study = appState.study
            self.onboardingForm = appState.study?.onboarding?.form
            self.emailAddress = appState.emailAddress
        }
    }
}
