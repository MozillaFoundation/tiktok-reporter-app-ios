//
//  TermsAndConditionsViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
//

import SwiftUI

extension TermsAndConditionsView {

    // MARK: - Routing

    struct Routing {
        var alert: Bool = false
        var studiesSheet: Bool = false
    }

    // MARK: - ViewModel

    class ViewModel: PresentationStateObject {

        // MARK: - PolicyType

        enum PolicyType {
            case general, studySpecific(Policy)
        }

        // MARK: - Injected

        @Injected(\.policiesService)
        var service: PoliciesServicing

        // MARK: - Private Properties

        private var policyType: PolicyType

        // MARK: - Properties

        private var appState: AppStateManager
        @Published
        var routingState: Routing = .init()
        @Published
        var state: PresentationState = .idle
        // TODO: - Rename to `policy` in case we use the same view for Privacy Policy
        @Published
        var termsOfService: Policy? = nil

        // MARK: - Lifecycle
    
        init(appState: AppStateManager, policyType: PolicyType = .general) {
            self.appState = appState
            self.policyType = policyType

            switch policyType {
            case .general:
                self.load()
            case let .studySpecific(policy):
                self.termsOfService = policy
                state = .success
            }
        }

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
            do {
                switch policyType {
                case .general:
                    try appState.save(true, for: .hasAcceptedGeneralTerms)
                case .studySpecific:
                    try appState.save(true, for: .hasAcceptedStudyTerms)
                }
                
            } catch let error {
                // TODO: - Show Error
                print(error.localizedDescription)
            }

            routingState.studiesSheet = true
        }
    }
}
