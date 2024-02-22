//
//  SampleHandler.swift
//  TikTok ReporterScreenCapture
//
//  Created by Sergiu Ghiran on 22.11.2023.
//

import ReplayKit
import AVFoundation

enum BroadcastError: Error {
    case wrongStatus
}

class SampleHandler: RPBroadcastSampleHandler {
    
    private let broadcastLimitSeconds: TimeInterval = 60 * 10
    private var stopBroadcastTimer: Timer?
    
    // MARK: - AVAssetWriter
    
    private var assetWriter: AVAssetWriter?
    private let writerQueue: DispatchQueue
    
    private lazy var videoInput: AVAssetWriterInput = {

        let compressionProperties: [String: Any] = [
            AVVideoExpectedSourceFrameRateKey: NSNumber(value: 60),
            AVVideoProfileLevelKey: "HEVC_Main_AutoLevel"
        ]
        
        let videoOutputSettings: [String: Any] = [
            AVVideoCodecKey : AVVideoCodecType.hevc,
            AVVideoWidthKey : UIScreen.main.bounds.size.width,
            AVVideoHeightKey : UIScreen.main.bounds.size.height,
            AVVideoCompressionPropertiesKey: compressionProperties
        ]
        
        let input = AVAssetWriterInput(mediaType: .video, outputSettings: videoOutputSettings)
        input.expectsMediaDataInRealTime = true
        
        return input
        
    }()
    
    private lazy var audioInput: AVAssetWriterInput = {

        let audioOutputSettings: [String: Any] = [
            AVNumberOfChannelsKey: 1,
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: AVAudioSession.sharedInstance().sampleRate
        ]

        let input = AVAssetWriterInput(mediaType: .audio, outputSettings: audioOutputSettings)
        input.expectsMediaDataInRealTime = true

        return input
    }()

    private lazy var inputs: [AVAssetWriterInput] = [
        videoInput,
        audioInput
    ]

    private var writerSessionStarted: Bool = false

    // MARK: - FileManager

    private let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(Strings.fileName)
    private let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Strings.appGroupID)?.appendingPathComponent(Strings.filePath)

    // MARK: - Lifecycle

    override init() {

        try? FileManager.default.removeItem(at: tempURL)

        if let previousRecordingURL = fileURL?.appendingPathComponent(Strings.fileName, isDirectory: false), FileManager.default.fileExists(atPath: previousRecordingURL.path) {
            try? FileManager.default.removeItem(atPath: previousRecordingURL.path)
        }
                
        writerQueue = DispatchQueue(label: Strings.writerQueueLabel)

        super.init()
    }

    // MARK: - Methods

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.stopBroadcastTimer = Timer.scheduledTimer(timeInterval: broadcastLimitSeconds, target: self, selector: #selector(self.stopBroadcast), userInfo: nil, repeats: false)
        }

        
        do {
            try assetWriter = AVAssetWriter(outputURL: tempURL, fileType: .mp4)
            try start()
        } catch {
            stopBroadcastTimer?.invalidate()
            assertionFailure(error.localizedDescription)
            finishBroadcastWithError(error)
            return
        }
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override func broadcastFinished() {

        do {
            try finish()
            stopBroadcastTimer?.invalidate()
        } catch {
            assertionFailure(error.localizedDescription)
            return
        }
    
        guard let fileURL else {
            return
        }

        do {
            try FileManager.default.createDirectory(at: fileURL, withIntermediateDirectories: true)
        } catch {
            assertionFailure(error.localizedDescription)
            return
        }

        let destination = fileURL.appendingPathComponent(tempURL.lastPathComponent)

        do {
            try FileManager.default.moveItem(at: tempURL, to: destination)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {

        guard
            sampleBuffer.isValid,
            CMSampleBufferDataIsReady(sampleBuffer)
        else {
            return
        }

        let isWriting = writerQueue.sync {
            assetWriter?.status == .writing
        }

        guard isWriting else {
            return
        }

        writerQueue.sync {

            startSessionIfNeeded(sampleBuffer: sampleBuffer)

            switch sampleBufferType {
            case RPSampleBufferType.video:
                if videoInput.isReadyForMoreMediaData {
                    videoInput.append(sampleBuffer)
                }
            case RPSampleBufferType.audioApp:
                if audioInput.isReadyForMoreMediaData {
                    audioInput.append(sampleBuffer)
                }
            case RPSampleBufferType.audioMic:
                break
            @unknown default:
                // Handle other sample buffer types
                fatalError("Unknown type of sample buffer")
            }
        }
    }

    // MARK: - Helpers

    private func start() throws {

        try writerQueue.sync {
            guard
                let assetWriter,
                assetWriter.status == .unknown
            else {
                throw BroadcastError.wrongStatus
            }

            inputs
                .lazy
                .filter(assetWriter.canAdd(_:))
                .forEach(assetWriter.add(_:))

            assetWriter.startWriting()

            try assetWriter.error.map {
                throw $0
            }
        }
    }

    private func finish() throws {

        try writerQueue.sync {
            inputs
                .lazy
                .filter { $0.isReadyForMoreMediaData }
                .forEach { $0.markAsFinished() }

            guard
                let assetWriter,
                assetWriter.status == .writing
            else {
                throw BroadcastError.wrongStatus
            }

            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()

            var error: Error?

            assetWriter.finishWriting {
                defer {
                    dispatchGroup.leave()
                }

                if let writerError = assetWriter.error {
                    error = writerError
                }

                guard
                    assetWriter.status == .completed
                else {
                    error = BroadcastError.wrongStatus
                    return
                }
            }
        
            dispatchGroup.wait()

            try error.map {
                throw $0
            }
        }
    }

    private func startSessionIfNeeded(sampleBuffer: CMSampleBuffer) {

        guard !writerSessionStarted else {
            return
        }

        assetWriter?.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
        writerSessionStarted = true
    }
}

private enum Strings {
    static let fileName = "screenRecording.mp4"
    static let appGroupID = "group.org.mozilla.ios.TikTok-Reporter"
    static let filePath = "Library/Documents/"
    static let writerQueueLabel = "BroadcastExtension.assetWriterQueue"
}

private extension SampleHandler {
    @objc
    func stopBroadcast() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            finishBroadcastGracefully(self)
        }
    }
}
