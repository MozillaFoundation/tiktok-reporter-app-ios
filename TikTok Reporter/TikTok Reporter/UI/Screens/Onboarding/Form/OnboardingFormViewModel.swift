//
//  OnboardingFormViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 08.11.2023.
//

import SwiftUI

extension OnboardingFormView {

    // MARK: - ViewModel

    class ViewModel: ObservableObject {
        
        // MARK: - Injected

        // TODO: - Check if we need appState here
        private var appState: AppStateManager

        // MARK: - Properties

        var form: Form

        // MARK: - Lifecycle

        init(appState: AppStateManager, form: Form) {
            self.appState = appState
            self.form = form
        }

        // MARK: - Methods

        func saveData() {
            // TODO: - Add Glean integration
            do {
                try appState.save(true, for: .hasSentOnboardingForm)
            } catch let error {
                // TODO: - Add error handling
                print(error.localizedDescription)
            }
        }
    }
}
