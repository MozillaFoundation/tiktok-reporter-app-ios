//
//  TermsAndConditionsViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
//

import Combine

extension TermsAndConditionsView {

    // MARK: - Routing

    struct Routing {
        var alert: Bool = false
        var studiesSheet: Bool = false
    }

    // MARK: - ViewModel

    class ViewModel: PresentationStateObject {

        // MARK: - Injected

        @Injected(\.policiesService)
        var service: PoliciesServicing

        // MARK: - Properties

        @Published
        var routingState: Routing = .init()
        @Published
        var state: PresentationState = .idle
        @Published
        var termsOfService: Policy? = nil

        // MARK: - Methods

        func load() {
            state = .loading

            Task {
                do {
                    let termsOfService: Policy? = try await service.getTermsAndConditions()

                    await MainActor.run {
                        self.termsOfService = termsOfService
                        state = .success
                    }
                } catch let error {
                    // TODO: - Handle error
                    state = .failed
                    print(error.localizedDescription)
                }
            }
        }

        func showAlert() {
            routingState.alert = true
        }

        func showStudiesScreen() {
            routingState.studiesSheet = true
        }
    }
}
