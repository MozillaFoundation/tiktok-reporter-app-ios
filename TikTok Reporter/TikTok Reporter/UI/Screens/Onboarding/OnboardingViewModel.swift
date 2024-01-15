//
//  OnboardingViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 04.11.2023.
//

import SwiftUI

extension OnboardingView {

    // MARK: - ViewModel

    class ViewModel: ObservableObject {

        // MARK: - Properties

        private var appState: AppStateManager

        @Published
        var steps: [OnboardingStep] = []
        @Published
        var currentStep: Int = 0

        // MARK: - Lifecycle

        init(appState: AppStateManager, onboarding: Onboarding) {
            self.appState = appState
            self.steps = onboarding.steps
            self.steps.sort { $0.order < $1.order }
        }
 
        // MARK: - Methods

        func index(of step: OnboardingStep) -> Int {
            return steps.firstIndex(of: step) ?? 0
        }
        
        func nextStep() {
            guard currentStep < steps.count - 1 else {
                self.skip()
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

        func skip() {
            appState.updateOnboarding()
        }
    }
}
