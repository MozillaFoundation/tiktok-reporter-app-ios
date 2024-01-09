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
        @Injected(\.gleanManager)
        private var gleanManager: GleanManaging

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
            self.formUIContainer = FormInputMapper.map(form: form)

            if
                location == .settings,
                let emailAddress = appState.emailAddress,
                !formUIContainer.items.isEmpty
            {
                formUIContainer.items[0].stringValue = emailAddress
            }
        }

        // MARK: - Methods

        func saveData() {

            guard
                formUIContainer.validate(),
                let emailItem = formUIContainer.items.first,
                !emailItem.stringValue.isEmpty,
                let study = appState.study,
                let uuid = UUID(uuidString: study.id)
            else {
                return
            }

            let emailAddress = emailItem.stringValue
            
            do {

                gleanManager.setEmail(emailAddress, identifier: uuid)
                gleanManager.submit()

                try appState.save(emailAddress, for: .emailAddress)
            } catch {
                assertionFailure(error.localizedDescription)
            }

            switch location {
            case .onboarding:

                appState.updateOnboarding()
            default:

                break
            }
            
        }
    
        func skip() {
            appState.updateOnboarding()
        }
    }
}
