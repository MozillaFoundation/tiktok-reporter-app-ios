//
//  ReportViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 13.11.2023.
//

import SwiftUI
import AVFoundation

extension ReportView {

    // MARK: - Routing

    struct Routing {
        var videoEditor: Bool = false
        var submissionResult: Bool = false
    }
    
    // MARK: - ViewModel
    
    class ViewModel: PresentationStateObject {
        
        // MARK: - Injected
        
        @Injected(\.studiesService)
        private var studiesService: StudiesServicing
        @Injected(\.screenRecordingService)
        private var screenRecordingService: ScreenRecordingServicing
        
        // MARK: - Properties
        
        private(set) var form: Form
        private(set) var appState: AppStateManager
        
        var screenRecordingURL: URL? {
            screenRecordingService.localURL
        }

        var hasScreenRecording: Bool {
            return tabs.contains(.recordSession)
        }
        
        @Published
        var state: PresentationState = .success
        @Published
        var routingState: Routing = .init()

        @Published
        var selectedTab: Int = 0
        @Published
        var formUIContainer: FormUIContainer

        @Published
        var didUpdateMainField: Bool = false

        @Published
        var screenRecording: ScreenRecording?
        @Published
        var trimmedVideoPath: String?
        
        var tabs: [FormTab]
        
        // MARK: - Lifecycle
        
        init(form: Form, appState: AppStateManager) {

            self.form = form
            self.appState = appState
            
            self.formUIContainer = FormUIMapper.map(form: form)
            self.tabs = [.reportLink]

            if let study = appState.study, study.supportsRecording {
                tabs.append(.recordSession)
            }
            
            self.load()

            guard tabs.contains(.recordSession) else {
                return
            }

            if let asset = try? screenRecordingService.loadRecording() {
                self.setupScreenRecording(with: asset)
            }
        }
        
        // MARK: - Methods
        
        func load() {

            guard let study = appState.study else {
                return
            }
            
            state = .loading
            
            Task {
                do {
                    var apiStudies: [Study]? = try await studiesService.getStudies()
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
        
        func refreshRecording() {

            guard 
                screenRecording == nil,
                let asset = try? screenRecordingService.loadRecording()
            else {
                return
            }

            setupScreenRecording(with: asset)
        }

        func updateScreenRecording() {
            guard
                let trimmedVideoPath,
                let newAsset = try? screenRecordingService.updateLocalRecording(with: trimmedVideoPath)
            else {
                return
            }

            self.setupScreenRecording(with: newAsset)
        }

        // MARK: - Private Methods
    
        private func setupScreenRecording(with asset: AVAsset) {
            
            var screenRecording = ScreenRecording(asset: asset)
            
            state = .loading
            
            Task.init {
                do {
                    try await screenRecording.loadMetadata()
                    
                    await MainActor.run {
                        
                        asset.generateThumbnail { image in
                            
                            DispatchQueue.main.async {
                                screenRecording.setThumbnail(image ?? .settings)
                                
                                self.screenRecording = screenRecording
                                self.didUpdateMainField = true
                                self.state = .success
                            }
                        }
                    }
                } catch {
                    print("ScreenRecordingData load failed")
                    state = .failed
                }
            }
        }
        
        func cancelReport() {
            formUIContainer.items[0].stringValue = ""
            formUIContainer.items[0].isEnabled = true
            
            didUpdateMainField = false
        }
        
        func cancelRecording() {
            try? screenRecordingService.removeRecording()

            didUpdateMainField = false
            screenRecording = nil
        }
    }
}
