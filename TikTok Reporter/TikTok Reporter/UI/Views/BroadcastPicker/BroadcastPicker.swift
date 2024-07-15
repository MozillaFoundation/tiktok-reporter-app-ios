//
//  BroadcastPicker.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 23.11.2023.
//

import ReplayKit
import SwiftUI

struct BroadcastPicker: UIViewRepresentable {
    var startRecordingStatusChecker: () -> Void
    @State private var pickerView = RPSystemBroadcastPickerView(frame: CGRect(origin: .zero, size: CGSize(width: 64, height: 64)))

    func makeCoordinator() -> Coordinator {
        Coordinator(self, startRecordingStatusChecker: startRecordingStatusChecker)
    }

    class Coordinator: NSObject {
        var parent: BroadcastPicker
        var startRecordingStatusChecker: () -> Void

        init(_ parent: BroadcastPicker, startRecordingStatusChecker: @escaping () -> Void) {
            self.parent = parent
            self.startRecordingStatusChecker = startRecordingStatusChecker
        }

        @objc func pickerAction() {
            startRecordingStatusChecker()
        }
    }

    func showPickerView() {
        for subview in pickerView.subviews {
            if let button = subview as? UIButton {
                button.sendActions(for: .touchUpInside)
            }
        }
    }

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()

        for subview in pickerView.subviews {
            if let button = subview as? UIButton {
                button.addTarget(context.coordinator, action: #selector(Coordinator.pickerAction), for: .touchUpInside)
            }
        }

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
