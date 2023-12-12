//
//  RecordViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 07.12.2023.
//

import Foundation
import AVFoundation

extension RecordView {

    // MARK: - Routing

    struct Routing {
        var videoEditor: Bool = false
        var submissionResult: Bool = false
    }

    // MARK: - ViewModel
    
    final class ViewModel: PresentationStateObject {

        // MARK: - Injected

        @Injected(\.screenRecordingService)
        private var screenRecordingService: ScreenRecordingServicing
        @Injected(\.gleanManager)
        private var gleanManager: GleanManaging

        // MARK: - Properties

        @Published
        var state: PresentationState = .success
        @Published
        var routingState: Routing = .init()

        
        @Published
        var screenRecording: ScreenRecording?
        @Published
        var didUpdateMainField: Bool = false
        @Published
        var trimmedVideoPath: String?

        @Published
        var videoComments: String = ""

        var screenRecordingURL: URL? {
            screenRecordingService.localURL
        }

        // MARK: - Lifecycle

        init() {
            load()
        }

        // MARK: - Methods

        func load() {

            guard let asset = try? screenRecordingService.loadRecording() else {
                return
            }
                
            self.setupScreenRecording(with: asset)
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

        func submitRecording() {

            state = .loading

            Task {

                do {

                    let storage = try await screenRecordingService.uploadRecording()
                    let jsonString = try JSONMapper.map(storage)

                    gleanManager.setScreenRecording(jsonString)
                    gleanManager.submit()

                    state = .success

                    self.cancelRecording()
                    self.routingState.submissionResult = true
                } catch {
                    state = .failed
                    print(error.localizedDescription)
                }
            }
        }

        func cancelRecording() {
            try? screenRecordingService.removeRecording()

            didUpdateMainField = false
            screenRecording = nil
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
    }
}
