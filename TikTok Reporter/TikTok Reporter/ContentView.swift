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
    @Injected(\.gleanManager)
    private var gleanManager: GleanManaging

    // MARK: - Body

    var body: some View {
        NavigationView {
            content
        }
        .tint(.text)
        .onAppear {
            gleanManager.setup()
        }
    }

    // MARK: - Views
    
    @ViewBuilder
    private var content: some View {

        if !appState.hasAcceptedGeneralTerms {
            
            PolicyView(viewModel: .init(appState: appState))
        } else if let currentStep = appState.onboardingFlow?.currentStep {

            switch currentStep {
            case .policy(let policy):

                PolicyView(viewModel: .init(appState: appState, policyType: .specific(policy), hasActions: true))
            case .onboarding(let onboarding):

                OnboardingView(viewModel: .init(appState: appState, onboarding: onboarding))
            case .form(let form):

                OnboardingFormView(viewModel: .init(appState: appState, form: form))
            }

        } else if !appState.hasCompletedOnboarding {

            StudySelectionView(viewModel: .init(appState: appState))

        } else if let form = appState.study?.form {

            MainView(viewModel: .init(form: form, appState: appState))
        }
    }
}

#Preview {
    ContentView()
}
