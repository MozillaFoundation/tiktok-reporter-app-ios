//
//  OnboardingFlow.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 16.11.2023.
//

import Foundation

// TODO: - Rename
enum TestOnboardingStep: Equatable {
    case policy(Policy)
    case onboarding(Onboarding)
    case form(Form)
}

struct OnboardingFlow {

    let steps: [TestOnboardingStep]
    var currentStep: TestOnboardingStep?

    init(study: Study) {
        var onboardingSteps = [TestOnboardingStep]()

        if let policy = study.policies.first(where: { $0.type == .termsOfService }) {
            onboardingSteps.append(.policy(policy))
        }
    
        if let onboarding = study.onboarding {
            onboardingSteps.append(.onboarding(onboarding))

            if let form = onboarding.form {
                onboardingSteps.append(.form(form))
            }
        }

        self.steps = onboardingSteps
        self.currentStep = onboardingSteps.first
    }

    mutating func nextStep() -> TestOnboardingStep? {
        guard
            let currentStep = currentStep,
            let index = steps.firstIndex(of: currentStep),
            index < steps.count - 1
        else {
            return nil
        }

        self.currentStep = steps[index + 1]
        return currentStep
    }

    func isLastStep() -> Bool {
        guard
            let currentStep = currentStep,
            let index = steps.firstIndex(of: currentStep)
        else {
            return false
        }

        return index == steps.count - 1
    }
}
