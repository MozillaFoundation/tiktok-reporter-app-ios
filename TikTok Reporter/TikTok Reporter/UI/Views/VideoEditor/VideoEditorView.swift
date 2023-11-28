//
//  VideoEditorView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 27.11.2023.
//

import SwiftUI

class VideoEditorDelegate: NSObject, UIVideoEditorControllerDelegate, UINavigationControllerDelegate, ObservableObject {
    
    @Binding
    var trimmedVideoPath: String?

    init(trimmedVideoPath: Binding<String?>) {
        self._trimmedVideoPath = trimmedVideoPath
        super.init()
    }

    func videoEditorController(_ editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
        self.trimmedVideoPath = editedVideoPath
    }
}

struct VideoEditorView: UIViewControllerRepresentable {
    
    var videoFilePath: String
    @Binding
    var trimmedVideoPath: String?
    @ObservedObject
    private var delegate: VideoEditorDelegate

    init(videoFilePath: String, trimmedVideoPath: Binding<String?>) {
        self.videoFilePath = videoFilePath
        self._trimmedVideoPath = trimmedVideoPath
        self.delegate = VideoEditorDelegate(trimmedVideoPath: _trimmedVideoPath)
    }

    func makeUIViewController(context: Context) -> UIVideoEditorController {
        let controller = UIVideoEditorController()
    
        controller.videoPath = videoFilePath
        controller.delegate = delegate

        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIVideoEditorController, context: Context) {
    }
}
