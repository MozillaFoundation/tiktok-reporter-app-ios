//
//  OnboardingViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 04.11.2023.
//

import SwiftUI

extension OnboardingView {

    // MARK: - Routing

    struct Routing {
        var emailSheet: Bool = false
    }

    // MARK: - ViewModel

    class ViewModel: ObservableObject {

        // MARK: - Properties

        private var appState: AppStateManager
        @Published
        var routingState: Routing = .init()
        @Published
        var steps: [OnboardingStep] = []
        @Published
        var currentStep: Int = 0

        // MARK: - Lifecycle

        init(appState: AppStateManager, onboarding: Onboarding) {
            self.appState = appState
            self.steps = onboarding.steps
        }
 
        // MARK: - Methods

        func setup(with appState: AppStateManager) {
            self.appState = appState
        }

        func index(of step: OnboardingStep) -> Int {
            return steps.firstIndex(of: step) ?? 0
        }
        
        func nextStep() {
            guard currentStep < steps.count - 1 else {
                self.finishOnboarding()
                return
            }

            withAnimation {
                currentStep += 1
            }
        }

        func previousStep() {
            guard currentStep > 0 else {
                return
            }

            withAnimation {
                currentStep -= 1
            }
        }

        func finishOnboarding() {
            do {
                try appState.save(true, for: .hasCompletedOnboarding)
            } catch let error {
                // TODO: - Add error handling
                print(error.localizedDescription)
            }
        }
    }
}
