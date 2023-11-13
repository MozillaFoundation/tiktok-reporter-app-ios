//
//  StudySelectionViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 02.11.2023.
//

import SwiftUI

extension StudySelectionView {

    // MARK: - Routing

    struct Routing {

        enum StudyRoute: Identifiable, Hashable {
            case policy
            case onboarding(Onboarding)
            case onboardingForm(Form)
            case form(Form)

            var id: Self {
                return self
            }
        }

        var studySheet: StudyRoute? = nil
    }

    // MARK: - ViewModel

    class ViewModel: PresentationStateObject {

        // MARK: - Injected

        @Injected(\.studiesService)
        private var service: StudiesServicing

        // MARK: - Properties

        private var appState: AppStateManager
        @Published
        var state: PresentationState = .idle
        @Published
        var studies: [Study] = []
        @Published
        var selected: Study?

        // MARK: - Lifecycle

        init(appState: AppStateManager) {
            self.appState = appState
        }

        // MARK: - Methods
    
        func setup(with appState: AppStateManager) {
            self.appState = appState
        }

        func load() {
            state = .loading

            Task {
                do {
                    let apiStudies: [Study]? = try await service.getStudies()

                    await MainActor.run {
                        guard let studies = apiStudies, studies.contains(where: { $0.form != nil }) else {
                            state = .idle
                            return
                        }
                    
                        self.studies = studies.filter({ $0.form != nil })
                        selected = studies.first(where: { $0.isActive })

                        state = .success
                    }
                } catch let error {
                    // TODO: - Handle error
                    state = .failed
                    print(error.localizedDescription)
                }
            }
        }
    
        func saveStudy() {
            // TODO: - Show error to user
            guard let study = selected else {
                return
            }

            do {
                try appState.save(study, for: .study)
            } catch let error {
                // TODO: - Add error handling
                print(error.localizedDescription)
            }
        }
    }
}
