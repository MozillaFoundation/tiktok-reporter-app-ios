//
//  PolicyViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
//

import SwiftUI

extension PolicyView {

    // MARK: - Routing

    struct Routing {
        var alert: Bool = false
    }

    // MARK: - ViewModel

    final class ViewModel: PresentationStateObject {

        // MARK: - PolicyType

        enum PolicyType {
            case general, specific(Policy)
        }

        // MARK: - Injected

        @Injected(\.policiesService)
        private var service: PoliciesServicing

        // MARK: - Properties

        private(set) var appState: AppStateManager
        private(set) var policyType: PolicyType

        @Published
        var routingState: Routing = .init()
        @Published
        var state: PresentationState = .idle
        @Published
        var policy: Policy? = nil
        
        var policyText: AttributedString {
            (try? AttributedString(styledMarkdown: policy?.text ?? "")) ?? AttributedString()
        }

        var hasActions: Bool

        // MARK: - Lifecycle
    
        init(appState: AppStateManager, policyType: PolicyType = .general, hasActions: Bool = true) {
            self.appState = appState
            self.policyType = policyType
            self.hasActions = hasActions

            switch policyType {
            case .general:
                self.load()
            case let .specific(policy):
                self.policy = policy
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
                        self.policy = termsOfService
                        state = .success
                    }
                } catch let error {
                    state = .failed
                    // TODO: if it's internet issue there will be another message
                }
            }
        }

        func showAlert() {
            routingState.alert = true
        }

        func handleAgree() {
            do {
                switch policyType {
                case .general:
                    try appState.save(true, for: .hasAcceptedGeneralTerms)
                case .specific:
                    appState.updateOnboarding()
                }
                
            } catch let error {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
