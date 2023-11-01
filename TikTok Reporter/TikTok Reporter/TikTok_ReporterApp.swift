//
//  TikTok_ReporterApp.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 27.10.2023.
//

import SwiftUI

@main
struct TikTok_ReporterApp: App {
    var body: some Scene {
        WindowGroup {
            TermsAndConditionsView(viewModel: .init())
        }
    }
}
