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
        var alert: Bool = false
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

        private var appState: AppStateManager

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
        
        @Published
        var didUserTryToSubmitWithoutRecording: Bool = false

        var screenRecordingURL: URL? {
            screenRecordingService.localURL
        }

        // MARK: - Lifecycle

        init(appState: AppStateManager) {

            self.appState = appState
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
            
            guard screenRecording != nil else {
                didUserTryToSubmitWithoutRecording = true
                return
            }
                        
            guard
                let study = appState.study,
                let uuid = UUID(uuidString: study.id)
            else {
                state = .failed(nil)
                return
            }

            state = .loading
            
            videoComments = ""

            Task {

                do {

                    let storage = try await screenRecordingService.uploadRecording()
                    let jsonString = try JSONMapper.map(storage)
                    
                    let jsonStringToScreenRecording = prepareScreenRecording(jsonString: jsonString)
                    
                    gleanManager.setScreenRecording(jsonStringToScreenRecording, identifier: uuid)
                    gleanManager.submitScreenRecording()

                    state = .success

                    self.cancelRecording()
                    self.routingState.submissionResult = true
                } catch {
                    state = .failed(error)
                    print(error.localizedDescription)
                }
            }
        }

        func prepareScreenRecording(jsonString: String) -> String {
            var screenRecordingDict: [String: Any] = [:]
            
            if let jsonDataRepresentation = jsonString.data(using: .utf8),
               let jsonObject = try? JSONSerialization.jsonObject(with: jsonDataRepresentation) as? [String:Any] {
                screenRecordingDict["recordingInfo"] = jsonObject
            }
            
            screenRecordingDict["comments"] = videoComments
            
            guard let jsonSerializedData = try? JSONSerialization.data(withJSONObject: screenRecordingDict, options: .prettyPrinted) else {
                return jsonString
            }
            
            guard let jsonSerializedString = String(data: jsonSerializedData, encoding: .utf8) else { return jsonString }
            
            return jsonSerializedString
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
                                self.didUserTryToSubmitWithoutRecording = false
                                self.state = .success
                            }
                        }
                    }
                } catch {
                    print("ScreenRecordingData load failed")
                    state = .failed(error)
                }
            }
        }
    }
}
