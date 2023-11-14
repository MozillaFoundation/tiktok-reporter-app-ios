//
//  TikTok_ReporterApp.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 27.10.2023.
//

import SwiftUI

@main
struct TikTok_ReporterApp: App {

    // MARK: - State
    
    @ObservedObject
    var appState = AppStateManager()

    // MARK: - Body

    var body: some Scene {

        WindowGroup {
            if !appState.hasAcceptedGeneralTerms {

                TermsAndConditionsView(viewModel: .init(appState: appState))
            } else if appState.study == nil {

                StudySelectionView(viewModel: .init(appState: appState))
            } else if !appState.hasAcceptedStudyTerms, let policy = appState.study?.policies.first {
                
                TermsAndConditionsView(viewModel: .init(appState: appState, policyType: .studySpecific(policy)))
            } else if !appState.hasCompletedOnboarding, let onboarding = appState.study?.onboarding {

                OnboardingView(viewModel: .init(appState: appState, onboarding: onboarding))
            } else if !appState.hasSentOnboardingForm, let form = appState.study?.onboarding?.form {

                OnboardingFormView(viewModel: .init(appState: appState, form: form))
            } else {

                // TODO: - Add main screen
                Text("Not implemented")
            }
        }
    }
}
