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
                    }
            }
        }
    }

    // MARK: - Views

    private var content: some View {

        VStack {

            PagedTabView(selectedTab: $viewModel.selectedTab, tabs: viewModel.tabs)
                .background(.white)

            TabView(selection: $viewModel.selectedTab) {
                reportTab
                    .tag(0)
                recordTab
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }

    private var reportTab: some View {
        
        VStack {

            FormView(viewModel: .init(formUIContainer: $viewModel.formUIContainer, didUpdateMainField: $viewModel.didUpdateMainField))

            VStack {
                MainButton(text: "Submit Report", type: .action) {
                    let isValid = viewModel.formUIContainer.validate()
                    print(isValid)
                }
            
                if viewModel.didUpdateMainField {
                    MainButton(text: "Cancel Report", type: .secondary) {
                        viewModel.cancelReport()
                    }
                }
            }
            .padding(.horizontal, .xl)
        }
    }

    private var recordTab: some View {
        
        VStack {

            ScrollView {

                VStack(alignment: .leading, spacing: .xl) {
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
                MainButton(text: "Submit Report", type: .action) {
                    // TODO: - Add logic once GLEAN is integrated
                }

                if viewModel.didUpdateMainField {
                    MainButton(text: "Cancel Report", type: .secondary) {
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
            Text("Record a TikTok session")
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
                MainButton(text: "Trim Recording", type: .secondary) {
                    viewModel.routingState.videoEditor = true
                }
            }
    }

    @ViewBuilder
    private var screenRecording: some View {

        if let screenRecording = viewModel.screenRecording {
            
            HStack(alignment: .top, spacing: .xl) {

                // TODO: - Find other solution than .settings
                Image(uiImage: screenRecording.thumbnail ?? .settings)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()

                VStack(alignment: .leading) {
                    Text("Recorded Video")
                        .font(.body4)
                        .foregroundStyle(.text)

                    HStack {
                        Text("Duration: ")
                            .font(.body4)
                            .foregroundStyle(.text)

                        Text(screenRecording.duration.positionalTime)
                            .font(.body2)
                            .foregroundStyle(.text)
                        
                    }

                    if let recordingDate = screenRecording.recordingDate {

                        HStack {
                            Text("Recorded on: ")
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

#Preview {
    ReportView(viewModel: .init(form: PreviewHelper.mockReportForm, appState: AppStateManager()))
}
