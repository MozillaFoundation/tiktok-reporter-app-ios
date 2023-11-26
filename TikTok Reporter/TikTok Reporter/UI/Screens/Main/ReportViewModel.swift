//
//  ReportViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 13.11.2023.
//

import SwiftUI
import AVFoundation

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

        func loadRecording() {
            guard
                let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.org.mozilla.ios.TikTok-Reporter")?.appendingPathComponent("screenShare.mov"),
                FileManager().fileExists(atPath: fileURL.path)
            else {
                return
            }
        
            let asset = AVAsset(url: fileURL)
            let reader = try! AVAssetReader(asset: asset)
        }

        func cancelReport() {
            formUIContainer.items[0].stringValue = ""
            formUIContainer.items[0].isEnabled = true

            didUpdateMainField = false

            appState.clearLink()
        }
    }
}
