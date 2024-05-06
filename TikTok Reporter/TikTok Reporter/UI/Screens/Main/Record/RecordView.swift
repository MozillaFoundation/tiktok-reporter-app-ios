//
//  RecordView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 07.12.2023.
//

import SwiftUI



struct BroadcastPickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = BroadcastPicker

    var didStopRecording: () -> Void

    func makeUIViewController(context: Context) -> BroadcastPicker {
        let broadcastPicker = BroadcastPicker()
        broadcastPicker.delegate = context.coordinator
        return broadcastPicker
    }

    func updateUIViewController(_ uiViewController: BroadcastPicker, context: Context) {
        // Update the view controller if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, BroadcastPickerDelegate {
        var parent: BroadcastPickerView

        init(_ parent: BroadcastPickerView) {
            self.parent = parent
        }

        func didStopRecording() {
            parent.didStopRecording()
        }
    }
}



struct RecordView: View {

    // MARK: - Properties

    @StateObject
    var viewModel: ViewModel
    
    @Environment(\.scenePhase)
    var scenePhase

    // MARK: - Body

    var body: some View {

        PresentationStateView(viewModel: viewModel) {
            self.content
        }
        .sheet(isPresented: $viewModel.routingState.videoEditor) {

            if let path = viewModel.screenRecordingURL?.path {

                VideoEditorView(videoFilePath: path, trimmedVideoPath: $viewModel.trimmedVideoPath)
                    .onChange(of: viewModel.trimmedVideoPath) { path in

                        guard path != nil else {
                            return
                        }

                        self.viewModel.updateScreenRecording()
                        self.viewModel.routingState.videoEditor = false
                    }
            }
        }
        .onChange(of: scenePhase) { newPhase in
            
            guard newPhase == .active else {
                return
            }
//            viewModel.refreshRecording()
        }
        .customAlert(
            title: Strings.cancelReportAlertTitle,
            description: Strings.cancelReportAlertDescription,
            isPresented: $viewModel.routingState.alert,
            secondaryButton: {
                MainButton(text: Strings.cancelReportAlertSecondaryButtonTitle, type: .secondary) {
                    viewModel.routingState.alert = false
                }
            },
            primaryButton: {
                MainButton(text: Strings.cancelReportAlertPrimaryButtonTitle, type: .primary) {
                    viewModel.cancelRecording()
                    viewModel.routingState.alert = false
                }
            }
        )
    }

    // MARK: - Views

    @ViewBuilder
    private var content: some View {
        
        if viewModel.routingState.submissionResult {

            SubmissionSuccessView(isPresented: $viewModel.routingState.submissionResult)
        } else {
            VStack {

                ScrollView {

                    VStack(alignment: .leading, spacing: .xl) {

                        let hasVideoRecording = viewModel.screenRecording != nil
                        
                        Text(hasVideoRecording ? Strings.recordingTitle : Strings.noRecordingTitle)
                            .font(.body2)
                            .foregroundStyle(.text)
                        
                        if hasVideoRecording {
                            screenRecordingView
                        } else {
                            recordScreenView
                        }
                        
                        if viewModel.didUserTryToSubmitWithoutRecording {
                            Text(Strings.submitReportWarning)
                                .font(.body2)
                                .foregroundStyle(.error)
                        }
                        
                        MainTextField(text: $viewModel.videoComments, isValid: .constant(true), isEnabled: .constant(true), placeholder: Strings.commentsPlaceholder, isMultiline: true)
                    }
                    .padding(.xl)
                }

                self.buttonStack
            }
        }
    }

    private var recordScreenView: some View {

        VStack(alignment: .center, spacing: .l) {

            Text(Strings.recordTitle)
                .font(.heading5)
            
            ZStack {

                Circle()
                    .fill(.divider)
                    .frame(width: 64, height: 64)

                BroadcastPickerView(didStopRecording: viewModel.refreshRecording)
                    .frame(width: 64, height: 64)
            }.frame(maxWidth: .infinity)
        }
    }

    private var screenRecordingView: some View {

            VStack(spacing: .xl) {

                screenRecording
                MainButton(text: Strings.trimTitle, type: .secondary) {
                    viewModel.routingState.videoEditor = true
                }
            }
    }

    private var buttonStack: some View {
        
        VStack {

            if viewModel.didUpdateMainField {
                MainButton(text: Strings.submitTitle, type: .action) {
                    viewModel.submitRecording()
                }
            }

            if viewModel.didUpdateMainField {

                MainButton(text: Strings.cancelTitle, type: .secondary) {
                    viewModel.routingState.alert = true
                }
            }
        }
        .padding(.horizontal, .xl)
    }

    @ViewBuilder
    private var screenRecording: some View {

        if let screenRecording = viewModel.screenRecording {
            
            HStack(alignment: .top, spacing: .xl) {

                Image(uiImage: screenRecording.thumbnail ?? .error)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()

                VStack(alignment: .leading) {
                    Text(Strings.recordedVideo)
                        .font(.body4)
                        .foregroundStyle(.text)

                    HStack {
                        Text(Strings.duration)
                            .font(.body4)
                            .foregroundStyle(.text)

                        Text(screenRecording.duration.positionalTime)
                            .font(.body2)
                            .foregroundStyle(.text)
                        
                    }

                    if let recordingDate = screenRecording.recordingDate {

                        HStack {
                            Text(Strings.recordingDate)
                                .font(.body4)
                                .foregroundStyle(.text)
                            
                            Text(recordingDate.formattedDateString() + " at " + recordingDate.formattedTimeString())
                                .font(.body2)
                                .foregroundStyle(.text)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    RecordView(viewModel: .init(appState: AppStateManager()))
}

// MARK: - Strings

private enum Strings {
    static let submitTitle = "Submit Report"
    static let cancelTitle = "Cancel Report"
    static let recordTitle = "Record a TikTok session"
    static let trimTitle = "Trim Recording"
    static let recordedVideo = "Recorded Video"
    static let duration = "Duration:"
    static let recordingDate = "Recorded on:"
    static let commentsPlaceholder = "Comments(optional)"
    static let noRecordingTitle = "Tap ‘Record my TikTok session’ to start screen recording. Select ‘FYP ReporterScreenCapture’ and tap ‘Start Broadcast’, then tap outside the dialog to dismiss it. Open TikTok and record your session while you scroll the For You Page (FYP). Once you’re done, tap ‘Stop Recording’ or the circle below (which will be colored red while recording is on). You’ll be asked to share more information and submit this form."
    static let recordingTitle = "You’ve recorded a TikTok session. Fill out some information then submit the form."
    static let submitReportWarning = "Create a recording in order to submit the report."
    static let cancelReportAlertTitle = "Cancel Report?"
    static let cancelReportAlertDescription = "Are you sure you want to cancel the report? All the data entered will be deleted"
    static let cancelReportAlertPrimaryButtonTitle = "Delete"
    static let cancelReportAlertSecondaryButtonTitle = "Keep"
}
