//
//  ReportViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 13.11.2023.
//

import SwiftUI

extension ReportView {

    // MARK: - ViewModel

    class ViewModel: ObservableObject {

        // MARK: - Properties

        var form: Form
        var appState: AppStateManager

        @Published
        var selectedTab: Int = 0
        var tabs = ["Report a link", "Record a session"]

        // MARK: - Lifecycle

        init(form: Form, appState: AppStateManager) {
            self.form = form
            self.appState = appState
        }
    }
}
