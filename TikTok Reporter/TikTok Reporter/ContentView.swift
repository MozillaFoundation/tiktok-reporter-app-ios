//
//  ContentView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 27.10.2023.
//

import SwiftUI

struct ContentView: View {

    // MARK: - State
    
    @ObservedObject
    var appState = AppStateManager()

    // MARK: - Body

    var body: some View {
        NavigationView {
            content
        }
        .tint(.text)
    }

    // MARK: - Views

    @ViewBuilder
    private var content: some View {
        if !appState.hasAcceptedGeneralTerms {

            PolicyView(viewModel: .init(appState: appState))
        } else if appState.study == nil {

            StudySelectionView(viewModel: .init(appState: appState))
        } else if !appState.hasAcceptedStudyTerms, let policy = appState.study?.policies.first(where: { $0.type == .termsOfService }) {
            
            PolicyView(viewModel: .init(appState: appState, policyType: .specific(policy)))
        } else if !appState.hasCompletedOnboarding, let onboarding = appState.study?.onboarding {

            OnboardingView(viewModel: .init(appState: appState, onboarding: onboarding))
        } else if !appState.hasSentOnboardingForm, let form = appState.study?.onboarding?.form {

            OnboardingFormView(viewModel: .init(appState: appState, form: form))
        } else if let form = appState.study?.form {

            ReportView(viewModel: .init(form: form, appState: appState))
        }
    }
}

#Preview {
    ContentView()
}
