//
//  ReportViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 13.11.2023.
//

import SwiftUI

extension ReportView {
    
    // MARK: - ViewModel
    
    class ViewModel: PresentationStateObject {
        
        // MARK: - Injected
        
        @Injected(\.studiesService)
        private var service: StudiesServicing
        
        // MARK: - Properties
        
        var form: Form
        var appState: AppStateManager
        
        @Published
        var state: PresentationState = .success
        @Published
        var selectedTab: Int = 0
        @Published
        var formUIContainer: FormUIContainer
        @Published
        var didUpdateMainField: Bool = false

        var tabs = ["Report a link", "Record a session"]
        
        // MARK: - Lifecycle
        
        init(form: Form, appState: AppStateManager) {
            self.form = form
            self.appState = appState

            self.formUIContainer = FormUIMapper.map(form: form)

            self.load()
        }
        
        // MARK: - Methods
        
        func load() {
            guard let study = appState.study else {
                return
            }
            
            state = .loading
            
            Task {
                do {
                    var apiStudies: [Study]? = try await service.getStudies()
                    // TODO: - Remove before release
                    apiStudies?.append(TestStudyProvider.study)
                    
                    try await MainActor.run {
                        if let studies = apiStudies, !studies.contains(where: { $0.id == study.id && $0.isActive }) {
                            try appState.save(false, for: .hasCompletedOnboarding)
                        }
                        
                        state = .success
                    }
                } catch let error {
                    state = .failed
                    print(error.localizedDescription)
                }
            }
        }

        func cancelReport() {
            formUIContainer.items[0].stringValue = ""
            formUIContainer.items[0].isEnabled = true

            didUpdateMainField = false

            appState.clearLink()
        }

        func preFillLink() {
            appState.refreshLink()

            guard let tikTokLink = appState.tikTokLink, formUIContainer.items.count > 0 else {
                return
            }

            formUIContainer.items[0].stringValue = tikTokLink
            formUIContainer.items[0].isEnabled = false

            didUpdateMainField = true
        }
    }
}
