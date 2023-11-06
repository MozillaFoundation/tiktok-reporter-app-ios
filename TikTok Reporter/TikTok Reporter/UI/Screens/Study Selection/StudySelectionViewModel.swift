//
//  StudySelectionViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 02.11.2023.
//

import Foundation

extension StudySelectionView {

    // MARK: - Routing

    struct Routing {
        var onboardingSheet: Bool = false
    }

    // MARK: - ViewModel

    class ViewModel: PresentationStateObject {

        // MARK: - Injected

        @Injected(\.studiesService)
        private var service: StudiesServicing

        // MARK: - Properties

        @Published
        var routingState: Routing = .init()
        @Published
        var state: PresentationState = .idle
        @Published
        var studies: [Study] = []
        @Published
        var selected: Study?

        // MARK: - Methods

        func load() {
            state = .loading

            Task {
                do {
                    let studies: [Study]? = try await service.getStudies()

                    await MainActor.run {
                        self.studies = studies ?? []
                        selected = self.studies.first(where: { $0.isActive })

                        state = .success
                    }
                } catch let error {
                    // TODO: - Handle error
                    state = .failed
                    print(error.localizedDescription)
                }
            }
        }
    }
}
