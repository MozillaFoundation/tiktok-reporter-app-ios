//
//  PoliciesService.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
//

import Foundation

protocol PoliciesServicing {
    func getTermsAndConditions() async throws -> Policy?
}

final class PoliciesService: PoliciesServicing {

    // MARK: - Properties

    @Injected(\.apiClient)
    var apiClient: HTTPClient

    // MARK: - Methods

    func getTermsAndConditions() async throws -> Policy? {
        let policies: [Policy] = try await apiClient.perform(request: PoliciesAPI.getAppPolicies)
        return policies.first(where: { $0.type == .termsOfService })
    }
}
