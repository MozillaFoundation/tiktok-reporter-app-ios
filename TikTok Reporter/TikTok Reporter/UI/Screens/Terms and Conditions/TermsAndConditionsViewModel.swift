//
//  TermsAndConditionsViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
//

import Combine

extension TermsAndConditionsView {

    // MARK: - ViewModel

    class ViewModel: PresentationStateObject {

        // MARK: - Injected

        @Injected(\.policiesService)
        var service: PoliciesServicing

        @Published
        var state: PresentationState = .idle

        // MARK: - Properties

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
    }
}
