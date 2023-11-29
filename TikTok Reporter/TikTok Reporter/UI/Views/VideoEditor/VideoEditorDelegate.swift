//
//  VideoEditorDelegate.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 28.11.2023.
//

import SwiftUI

final class VideoEditorDelegate: NSObject, UIVideoEditorControllerDelegate, UINavigationControllerDelegate, ObservableObject {
    
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
