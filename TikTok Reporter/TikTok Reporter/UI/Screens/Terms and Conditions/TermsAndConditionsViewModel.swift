//
//  TermsAndConditionsViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
//

import Combine

extension TermsAndConditionsView {

    // MARK: - ViewModel

    class ViewModel: ObservableObject {

        // MARK: - Injected

        @Injected(\.policiesService)
        var service: PoliciesServicing

        // MARK: - Properties

        @Published
        var termsOfService: Policy? = nil

        // MARK: - Methods

        func getTerms() {
            Task {
                do {
                    let termsOfService: Policy? = try await service.getTermsAndConditions()

                    await MainActor.run {
                        self.termsOfService = termsOfService
                    }
                } catch let error {
                    // TODO: - Handle error
                    print(error.localizedDescription)
                }
            }
        }
    }
}
