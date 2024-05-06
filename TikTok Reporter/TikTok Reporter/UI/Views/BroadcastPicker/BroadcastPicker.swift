//
//  BroadcastPicker.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 23.11.2023.
//

//import ReplayKit
//import SwiftUI
//
//struct BroadcastPicker: UIViewRepresentable {
//
//    func makeUIView(context: Context) -> UIView {
//
//        // Needed for the PickerView centering. Without it, the button is off-center, no matter the frame given.
//        let containerView = UIView()
//
//        let pickerView = RPSystemBroadcastPickerView(frame: CGRect(origin: .zero, size: CGSize(width: 64, height: 64)))
//
//        pickerView.preferredExtension = "org.mozilla.ios.TikTok-Reporter.TikTok-ReporterScreenCapture"
//        pickerView.showsMicrophoneButton = false
//
//        containerView.addSubview(pickerView)
//    
//        pickerView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            pickerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            pickerView.topAnchor.constraint(equalTo: containerView.topAnchor),
//            pickerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            pickerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
//        ])
//
//        return containerView
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//    }
//}

import UIKit
import ReplayKit
import SwiftUI

protocol BroadcastPickerDelegate: AnyObject {
    func didStopRecording()
}
class BroadcastPicker: UIViewController {
    weak var delegate: BroadcastPickerDelegate?
    let recordButton = UIButton()
    var assetWriter: AVAssetWriter?
    var videoInput: AVAssetWriterInput?
    var audioInput: AVAssetWriterInput?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize the button to look like a circle
        recordButton.backgroundColor = .black
        recordButton.layer.cornerRadius = 12
        recordButton.frame = CGRect(x: 20, y: 20, width: 24, height: 24)

        // Add the button to the view
        view.addSubview(recordButton)

        // Set the button's action
        recordButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
    }
    
    @objc func toggleRecording() {
        let sharedRecorder = RPScreenRecorder.shared()

        if sharedRecorder.isRecording {
            sharedRecorder.stopCapture { (error) in
                if let error = error {
                    print("Failed to stop recording: \(error)")
                } else {
                    print("Recording stopped successfully")
                    self.assetWriter?.finishWriting {
                        print("Saved file", self.assetWriter?.outputURL.path ?? "")
                    }
                    DispatchQueue.main.async {
                        self.recordButton.backgroundColor = .black
                        self.delegate?.didStopRecording()
                    }
                }
            }
        } else {
            let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("screenRecording").appendingPathExtension("mov")
            self.assetWriter = try? AVAssetWriter(outputURL: outputURL, fileType: .mov)
            self.videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: nil)
//            self.audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: nil)
            self.assetWriter!.add(self.videoInput!)
//            self.assetWriter?.add(self.audioInput!)
            sharedRecorder.isCameraEnabled = true
            sharedRecorder.isMicrophoneEnabled = true

            sharedRecorder.startCapture(handler: { (sampleBuffer, bufferType, error) in

                if let error = error {
                    print("Failed to capture sample buffer: \(error)")
                    return
                }
                if !CMSampleBufferDataIsReady(sampleBuffer) {
                    print("Buffer not ready")
                } else {
                    if self.assetWriter!.status == AVAssetWriter.Status.unknown
                    {
                        self.assetWriter!.startWriting()
                        self.assetWriter!.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                    }

                    if self.assetWriter!.status == AVAssetWriter.Status.failed {
                        print("Error occured, status = \(self.assetWriter!.status.rawValue), \(self.assetWriter!.error!.localizedDescription) \(String(describing: self.assetWriter!.error))")
                        return
                    }
                    switch bufferType {
                    case .video:
                        if self.videoInput!.isReadyForMoreMediaData == true {
                            self.videoInput!.append(sampleBuffer)
                        }
                    case .audioApp:
                        break
                        //                    if self.audioInput?.isReadyForMoreMediaData == true {
                        //                        self.audioInput?.append(sampleBuffer)
                        //                    }
                    case .audioMic:
                        break // Ignore microphone audio
                    @unknown default:
                        break
                    }
                }
            }) { (error) in
                if let error = error {
                    print("Failed to start recording: \(error)")
                } else {
                    print("Recording started successfully")
                    DispatchQueue.main.async {
                        self.recordButton.backgroundColor = .red
                    }
                }
            }
        }
    }
}

// MARK: - Strings

private enum Strings {
    static let fileName = "screenRecording.mov"
    static let appGroupID = "group.org.mozilla.ios.TikTok-Reporter"
    static let appGroupFilePath = "Library/Documents/screenRecording.mov"
    static let signedURLBase = "https://storage.googleapis.com/ttreporter_recordings/"
}
