//
//  StudiesService.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 02.11.2023.
//

import Foundation

protocol StudiesServicing {
    func getStudies() async throws -> [Study]?
    func getOnboarding(with studyId: String) async throws -> Onboarding
}

final class StudiesService: StudiesServicing {

    // MARK: - Properties

    @Injected(\.apiClient)
    var apiClient: HTTPClient

    // MARK: - Methods

    func getStudies() async throws -> [Study]? {
        return try await apiClient.perform(request: StudiesAPI.getStudies)
    }

    func getOnboarding(with studyId: String) async throws -> Onboarding {
        return try await apiClient.perform(request: StudiesAPI.getOnboarding(id: studyId))
    }
}
