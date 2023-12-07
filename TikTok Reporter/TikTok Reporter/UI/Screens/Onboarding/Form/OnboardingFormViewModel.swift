//
//  OnboardingFormViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 08.11.2023.
//

import SwiftUI

extension OnboardingFormView {

    // MARK: - ViewModel

    final class ViewModel: ObservableObject {
    
        // MARK: - Location

        enum Location {
            case onboarding, settings
        }
        
        // MARK: - Injected

        private var appState: AppStateManager

        // MARK: - Properties

        @Published
        var formUIContainer: FormInputContainer
        @Published
        var didUpdateMainField = false
        var location: Location

        // MARK: - Lifecycle

        init(appState: AppStateManager, form: Form, location: Location = .onboarding) {
            self.appState = appState
            self.location = location
            self.formUIContainer = FormUIMapper.map(form: form)
        }

        // MARK: - Methods

        func saveData() {
            guard 
                formUIContainer.validate(),
                let emailItem = formUIContainer.items.first,
                !emailItem.stringValue.isEmpty
            else {
                return
            }

            let emailAddress = emailItem.stringValue
            
            do {
                GleanManager.submitText(emailAddress, metricType: .email)
                try appState.save(emailAddress, for: .emailAddress)
            } catch {
                assertionFailure(error.localizedDescription)
            }

            switch location {
            case .onboarding:
                appState.updateOnboarding()
            case .settings:
                print("Save tapped")
            }
            
        }
    
        func skip() {
            appState.updateOnboarding()
        }
    }
}
