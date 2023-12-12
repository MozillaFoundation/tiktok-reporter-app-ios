//
//  MainViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 07.12.2023.
//

import Foundation
 
extension MainView {

    // MARK: - ViewModel

    final class ViewModel: ObservableObject {

        // MARK: - Properties

        private(set) var appState: AppStateManager
        private(set) var form: Form

        private(set) var tabs: [FormTab] = [.reportLink]
        
        var hasScreenRecording: Bool {
            return tabs.contains(.recordSession)
        }

        @Published
        var selectedTab: Int = 0

        // MARK: - Lifecycle

        init(form: Form, appState: AppStateManager) {

            self.appState = appState
            self.form = form

            if let study = appState.study, study.supportsRecording {
                tabs.append(.recordSession)
            }
        }
    }
}
