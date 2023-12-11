//
//  RecordView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 07.12.2023.
//

import SwiftUI

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
                
            viewModel.refreshRecording()
        }
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

                BroadcastPicker()
                    .frame(height: 64)
            }
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

            MainButton(text: Strings.submitTitle, type: .action) {
                viewModel.submitRecording()
            }

            if viewModel.didUpdateMainField {

                MainButton(text: Strings.cancelTitle, type: .secondary) {
                    viewModel.cancelRecording()
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
    RecordView(viewModel: .init())
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
    static let noRecordingTitle = "To start screen recording, tap the button below. Then, open your TikTok app and record your session while you scroll the FYP. To stop recording, press the timer. You’ll be asked to share more information and submit this form."
    static let recordingTitle = "You’ve recorded a TikTok session. Fill out some information then submit the form."
}
