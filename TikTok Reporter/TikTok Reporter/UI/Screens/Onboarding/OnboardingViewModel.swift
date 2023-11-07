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

        @Published
        var routingState: Routing = .init()
        @Published
        var onboarding: Onboarding
        @Published
        var currentStep: Int = 0

        // MARK: - Lifecycle

        init(onboarding: Onboarding) {
            self.onboarding = onboarding
        }
 
        // MARK: - Methods

        func index(of step: OnboardingStep) -> Int {
            return onboarding.steps.firstIndex(of: step) ?? 0
        }
        
        func nextStep() {
            guard currentStep < onboarding.steps.count - 1 else {
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
            
        }
    }
}
