//
//  ReportView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 13.11.2023.
//

import SwiftUI

struct ReportView: View {

    // MARK: - Properties

    @ObservedObject
    var viewModel: ViewModel

    @State
    var text: String = ""

    @Environment(\.scenePhase) var scenePhase

    // MARK: - Body

    var body: some View {

        PresentationStateView(viewModel: viewModel) {
            self.content
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(.header)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: SettingsView(viewModel: .init(appState: viewModel.appState))) {
                    Image(.settings)
                        .renderingMode(.original)
                }
            }
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
    }

    // MARK: - Views

    private var content: some View {

        // TODO: - Would be best to separate the report and record tabs in separate View + ViewModel components to clean up code. Due to project time constraints this was left as-is.
        VStack {

            PagedTabView(selectedTab: $viewModel.selectedTab, tabs: viewModel.tabs.compactMap({ $0.tabTitle }))
                .background(.white)

            TabView(selection: $viewModel.selectedTab) {

                reportTab
                    .tag(0)

                if viewModel.hasScreenRecording {
                    recordTab
                        .tag(1)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }

    @ViewBuilder
    private var reportTab: some View {
        
        if viewModel.routingState.submissionResult {

            SubmissionSuccessView(isPresented: $viewModel.routingState.submissionResult)
        } else {

            VStack {
                
                FormView(viewModel: .init(formUIContainer: $viewModel.formUIContainer, didUpdateMainField: $viewModel.didUpdateMainField))
                
                VStack {
                    
                    MainButton(text: Strings.submitTitle, type: .action) {
                        viewModel.sendReport()
                        viewModel.routingState.submissionResult = true
                    }
                    
                    if viewModel.didUpdateMainField {
                        MainButton(text: Strings.cancelTitle, type: .secondary) {
                            viewModel.cancelReport()
                        }
                    }
                }
                .padding(.horizontal, .xl)
            }
        }
    }

    private var recordTab: some View {
        
        VStack {

            ScrollView {

                VStack(alignment: .leading, spacing: .xl) {
                    // TODO: - Add string update on video loaded
                    Text("To start screen recording, tap the button below. Then, open your TikTok app and record your session while you scroll the FYP. To stop recording, press the timer. You’ll be asked to share more information and submit this form.")
                        .font(.body2)
                        .foregroundStyle(.text)
                    
                    if viewModel.screenRecording == nil {
                        recordScreenView
                    } else {
                        screenRecordingView
                    }

                    // TODO: - Verify how we add this component after GLEAN integration
                    MainTextField(text: $text, isValid: .constant(true), isEnabled: .constant(true), placeholder: "Comments(optional)", isMultiline: true)
                }
                .padding(.xl)
            }

            VStack {
                MainButton(text: Strings.submitTitle, type: .action) {
                    // TODO: - Add logic once GLEAN is integrated
                }

                if viewModel.didUpdateMainField {
                    MainButton(text: Strings.cancelTitle, type: .secondary) {
                        viewModel.cancelRecording()
                    }
                }
            }
            .padding(.horizontal, .xl)
        }
        .onChange(of: scenePhase) { newPhase in
            
            guard newPhase == .active else {
                return
            }
                
            viewModel.refreshRecording()
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
    ReportView(viewModel: .init(form: PreviewHelper.mockReportForm, appState: AppStateManager()))
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
}
