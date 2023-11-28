//
//  InjectionKey.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
//

import Foundation

public protocol InjectionKey {
    associatedtype Value

    static var currentValue: Self.Value { get set }
}

// MARK: - Injection Keys

private struct APIClientKey: InjectionKey {
    static var currentValue: HTTPClient = APIClient()
}

private struct PoliciesServiceKey: InjectionKey {
    static var currentValue: PoliciesServicing = PoliciesService()
}

private struct StudiesServiceKey: InjectionKey {
    static var currentValue: StudiesServicing = StudiesService()
}

private struct ScreenRecordingServiceKey: InjectionKey {
    static var currentValue: ScreenRecordingServicing = ScreenRecordingService()
}

// MARK: - Injected Values

extension InjectedValues {

    // MARK: - API Client
    
    var apiClient: HTTPClient {
        get { Self[APIClientKey.self] }
        set { Self[APIClientKey.self] = newValue }
    }
    
    // MARK: - Services

    var policiesService: PoliciesServicing {
        get { Self[PoliciesServiceKey.self] }
        set { Self[PoliciesServiceKey.self] = newValue }
    }

    var studiesService: StudiesServicing {
        get { Self[StudiesServiceKey.self] }
        set { Self[StudiesServiceKey.self] = newValue }
    }

    var screenRecordingService: ScreenRecordingServicing {
        get { Self[ScreenRecordingServiceKey.self] }
        set { Self[ScreenRecordingServiceKey.self] = newValue }
    }
}

