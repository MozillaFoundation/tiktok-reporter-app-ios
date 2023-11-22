//
//  PresentationState.swift
//  TikTok ReporterShare
//
//  Created by Sergiu Ghiran on 21.11.2023.
//

import Foundation

enum PresentationState: Equatable {
    case failed
    case idle
    case loading
    case success
}

@MainActor
protocol PresentationStateObject: ObservableObject {
    var state: PresentationState { get }
    func load()
}
