//
//  PresentationState.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
//

import Foundation

enum PresentationState: Equatable {
    static func == (lhs: PresentationState, rhs: PresentationState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
            (.loading, .loading),
            (.success, .success):
            return true
        case (let .failed(error1), let .failed(error2)):
            guard let firstError = error1 as? NSError, let secondError = error2 as? NSError else {
                return false
            }

            guard firstError.code == secondError.code,
                  firstError.localizedDescription == secondError.localizedDescription else { return false }
            
            return true
        default: return false
        }
    }
    
    case failed(Error?)
    case idle
    case loading
    case success
}

@MainActor
protocol PresentationStateObject: ObservableObject {
    var state: PresentationState { get }
    func load()
}
