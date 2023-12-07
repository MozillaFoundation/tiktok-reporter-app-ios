//
//  VideoEditorView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 27.11.2023.
//

import SwiftUI

struct VideoEditorView: UIViewControllerRepresentable {

    // MARK: - Properties

    var videoFilePath: String
    @Binding
    var trimmedVideoPath: String?
    @ObservedObject
    private var delegate: VideoEditorDelegate

    // MARK: - Lifecycle

    init(videoFilePath: String, trimmedVideoPath: Binding<String?>) {
        self.videoFilePath = videoFilePath
        self._trimmedVideoPath = trimmedVideoPath
        self.delegate = VideoEditorDelegate(trimmedVideoPath: _trimmedVideoPath)
    }

    // MARK: - Methods

    func makeUIViewController(context: Context) -> UIVideoEditorController {
        let controller = UIVideoEditorController()
    
        controller.videoPath = videoFilePath
        controller.videoQuality = .typeHigh
        controller.delegate = delegate

        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIVideoEditorController, context: Context) {}
}
