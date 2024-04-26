//
//  BroadcastPicker.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 23.11.2023.
//

import ReplayKit
import SwiftUI

struct BroadcastPicker: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {

        // Needed for the PickerView centering. Without it, the button is off-center, no matter the frame given.
        let containerView = UIView()

        let pickerView = RPSystemBroadcastPickerView(frame: CGRect(origin: .zero, size: CGSize(width: 64, height: 64)))

        pickerView.preferredExtension = "org.mozilla.ios.TikTok-Reporter.TikTok-ReporterScreenCapture"
        pickerView.showsMicrophoneButton = false

        containerView.addSubview(pickerView)
    
        pickerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pickerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            pickerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
