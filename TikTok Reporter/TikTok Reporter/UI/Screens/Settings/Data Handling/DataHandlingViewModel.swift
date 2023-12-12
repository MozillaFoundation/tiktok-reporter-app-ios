//
//  DataHandlingViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 12.12.2023.
//

import SwiftUI

extension DataHandlingView {

    // MARK: - ViewModel

    final class ViewModel: ObservableObject {

        // MARK: - Injected

        @Injected(\.gleanManager)
        private var gleanManager: GleanManaging

        // MARK: - Properties

        private var appState: AppStateManager

        // MARK: - Lifecycle

        init(appState: AppStateManager) {
            self.appState = appState
        }

        // MARK: - Methods

        func requestDataDownload() {
            guard 
                let emailAddress = appState.emailAddress,
                let study = appState.study,
                let uuid = UUID(uuidString: study.id)
            else {
                return
            }

            gleanManager.setDownloadData(email: emailAddress, identifier: uuid)
        }

        func requestDataDelete() {
            gleanManager.setDeleteData()
        }
    }
}
