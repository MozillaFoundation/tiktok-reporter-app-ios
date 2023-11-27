//
//  VideoEditorView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 27.11.2023.
//

import SwiftUI

struct VideoEditorView: UIViewControllerRepresentable {
    
    var videoFilePath: String

    func makeUIViewController(context: Context) -> UIVideoEditorController {
        let controller = UIVideoEditorController()
    
        controller.videoPath = videoFilePath

        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIVideoEditorController, context: Context) {
    }
}
