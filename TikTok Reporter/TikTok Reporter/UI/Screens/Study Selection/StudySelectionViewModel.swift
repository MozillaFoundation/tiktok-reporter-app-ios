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
        var alert: Bool = false
    }

    // MARK: - ViewModel

    class ViewModel: PresentationStateObject {

        // MARK: - State

        enum State: Equatable {
            case empty, prefilled(Study)
        }

        // MARK: - Injected

        @Injected(\.studiesService)
        private var service: StudiesServicing

        // MARK: - Properties

        private(set) var appState: AppStateManager

        @Published
        var routingState: Routing = .init()
        @Published
        var state: PresentationState = .idle
        @Published
        var studies: [Study] = []
        @Published
        var selected: Study?

        var prefilledStudy: Study?
        var tempStudy: Study? = nil
        var viewState: State

        // MARK: - Lifecycle

        init(appState: AppStateManager, viewState: State = .empty) {
            self.appState = appState
            self.viewState = viewState

            if case let .prefilled(study) = viewState {
                prefilledStudy = study
                selected = study
            }
        }

        // MARK: - Methods

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

                        if selected == nil {
                            selected = self.studies.first(where: { $0.isActive })
                        }

                        state = .success
                    }
                } catch let error {
                    state = .failed(error)
                    print(error.localizedDescription)
                }
            }
        }
    
        func saveStudy() {
            guard let study = selected else {
                return
            }

            tempStudy = nil

            do {
                try appState.save(study, for: .study)
                try appState.save(false, for: .hasCompletedOnboarding)

                appState.setOnboarding(with: study)
            } catch let error {
                print(error.localizedDescription)
            }
        }

        func resetSelected() {
            selected = tempStudy
            tempStudy = nil
        }
    }
}
