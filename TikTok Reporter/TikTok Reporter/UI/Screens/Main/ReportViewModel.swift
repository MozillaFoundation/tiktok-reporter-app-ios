//
//  ReportViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 13.11.2023.
//

import SwiftUI
import AVFoundation


struct ScreenRecording {

    // MARK: - Properties

    private(set) var asset: AVAsset

    private(set) var thumbnail: UIImage?
    private(set) var duration: CMTime = .zero
    private(set) var recordingDate: Date? = nil

    // MARK: - Lifecycle

    init(asset: AVAsset) {
        self.asset = asset
    }

    // MARK: - Methods

    mutating func loadMetadata() async throws {
        self.duration = try await asset.load(.duration)
        self.recordingDate = try await asset.load(.creationDate)?.load(.dateValue)
    }

    mutating func setThumbnail(_ thumbnail: UIImage) {
        self.thumbnail = thumbnail
    }
}

extension ReportView {

    // MARK: - Routing

    struct Routing {
        var videoEditor: Bool = false
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
        
        // TODO: - Check if study supports record feature
        var tabs = ["Report a link", "Record a session"]
        
        // MARK: - Lifecycle
        
        init(form: Form, appState: AppStateManager) {

            self.form = form
            self.appState = appState
            
            self.formUIContainer = FormUIMapper.map(form: form)
            
            self.load()

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
            
//            guard
//                screenRecording == nil,
//                let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.org.mozilla.ios.TikTok-Reporter")?.appendingPathComponent("Library/Documents/screenRecording.mp4"),
//                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//            else {
//                assertionFailure("Either AppGroup or Documents directory not found.")
//                return
//            }
//            
//            do {
//                
//                guard FileManager.default.fileExists(atPath: containerURL.path) else {
//                    return
//                }
//                
//                let destinationURL = documentsURL.appendingPathComponent("screenRecording.mp4")
//                
//                try FileManager.default.removeItem(at: destinationURL)
//                try FileManager.default.copyItem(at: containerURL, to: destinationURL)
//                try FileManager.default.removeItem(at: containerURL)
//                
//                self.videoFileURL = destinationURL
//                
//                try loadScreenRecording(at: destinationURL)
//            } catch {
//                print("Error when copying file to local sandbox.")
//                state = .failed
//            }
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

            // TODO: - Check if it's still needed
            appState.clearLink()
        }
        
        func cancelRecording() {
            try? screenRecordingService.removeRecording()

            didUpdateMainField = false
            screenRecording = nil
        }
    }
}
