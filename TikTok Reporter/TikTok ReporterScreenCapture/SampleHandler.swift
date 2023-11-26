//
//  SampleHandler.swift
//  TikTok ReporterScreenCapture
//
//  Created by Sergiu Ghiran on 22.11.2023.
//

import ReplayKit
import AVFoundation

class SampleHandler: RPBroadcastSampleHandler {

    // MARK: - Properties

    private var assetWriter: AVAssetWriter?
 
    private var videoInput: AVAssetWriterInput?
    private var audioInput: AVAssetWriterInput?

    private var fileURL = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.org.mozilla.ios.TikTok-Reporter")?.appendingPathComponent("screenShare.mp4")

    // MARK: - Lifecycle

    override init() {
        guard let fileURL = fileURL else {
            return
        }
    
        assetWriter = try? AVAssetWriter(outputURL: fileURL, fileType: .mp4)

        let videoOutputSettings: [String: Any] = [
            AVVideoCodecKey : AVVideoCodecType.h264,
            AVVideoWidthKey : UIScreen.main.bounds.size.width,
            AVVideoHeightKey : UIScreen.main.bounds.size.height
        ]
        
        var channelLayout = AudioChannelLayout()
        channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_MPEG_5_1_D
        
        let audioOutputSettings: [String: Any] = [
            AVNumberOfChannelsKey: 1,
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100
        ]
        
        self.videoInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
        self.audioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: audioOutputSettings)
        
        videoInput?.expectsMediaDataInRealTime = true
        audioInput?.expectsMediaDataInRealTime = true

        guard let videoInput, let audioInput else {
            return
        }

        assetWriter?.add(videoInput)
        assetWriter?.add(audioInput)
    }

    // MARK: - Methods

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override func broadcastFinished() {
        videoInput?.markAsFinished()
        audioInput?.markAsFinished()
        
        assetWriter?.finishWriting {}
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        guard 
            let assetWriter,
            let videoInput,
            let audioInput
        else {
            return
        }

        if CMSampleBufferDataIsReady(sampleBuffer) {
            
            if assetWriter.status == .unknown {
                assetWriter.startWriting()
                assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
            }
        }

        if assetWriter.status == .failed {
            print("Error occured, status = \(String(describing: assetWriter.status.rawValue)), \(String(describing: assetWriter.error!.localizedDescription)) \(String(describing: assetWriter.error))")
            return
        }

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
