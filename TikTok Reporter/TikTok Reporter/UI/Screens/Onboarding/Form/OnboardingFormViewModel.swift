//
//  OnboardingFormViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 08.11.2023.
//

import SwiftUI
import Combine

extension OnboardingFormView {

    // MARK: - ViewModel

    final class ViewModel: ObservableObject {
    
        // MARK: - Location

        enum Location {
            case onboarding, settings, dataHandling
        }
        
        // MARK: - Injected

        private(set) var appState: AppStateManager
        @Injected(\.gleanManager)
        private var gleanManager: GleanManaging

        // MARK: - Properties

        @Published
        var formUIContainer: FormInputContainer
        var privacyPolicyText: AttributedString
        @Published
        var didUpdateMainField = false
        @Published
        var isDataDownloaded = false {
            didSet {
                viewDismissalModePublisher.send(isDataDownloaded)
            }
        }
        var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
        var location: Location
        
        @Published
        var shouldFormScrollToNonValidatedScope: Bool = false

        // MARK: - Lifecycle

        init(appState: AppStateManager, form: Form, location: Location = .onboarding) {
            self.isDataDownloaded = false
            self.appState = appState
            self.location = location
            self.formUIContainer = FormInputMapper.map(form: form)
            self.privacyPolicyText =  (try? AttributedString(styledMarkdown: Strings.privacyPolicyMarkdown)) ?? AttributedString()

            if
                location == .settings || location == .dataHandling,
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
            
            if self.location == .dataHandling {
                gleanManager.setDownloadData(email: emailAddress, identifier: uuid)
                gleanManager.submitDownloadData()
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.isDataDownloaded = true
                }
            } else {
                do {
                    gleanManager.setEmail(emailAddress, identifier: uuid)
                    gleanManager.submitEmail()
                    try appState.save(emailAddress, for: .emailAddress)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }

            switch location {
            case .onboarding:

                appState.updateOnboarding()
            default:
                break
            }
            
        }

        func removeEmail() {
            guard
                let study = appState.study,
                let uuid = UUID(uuidString: study.id)
            else {
                return
            }
            let emptyEmail = ""

            gleanManager.setEmail(emptyEmail, identifier: uuid)
            gleanManager.submitEmail()
            appState.clearEmail()
        }

        func skip() {
            appState.updateOnboarding()
        }
    }
}

// MARK: - Strings

private enum Strings {
    static let privacyPolicyMarkdown = "By providing your email address, you agree to Mozilla's [Privacy Notice](https://foundation.mozilla.org/en/fyp-reporter/privacy-notice/)."
}
