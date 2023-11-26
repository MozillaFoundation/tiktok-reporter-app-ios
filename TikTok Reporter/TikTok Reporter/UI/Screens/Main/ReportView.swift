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
    var recordStarted: Bool = false
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

                    MainTextField(text: $text, isValid: .constant(true), isEnabled: .constant(true), placeholder: "Comments(optional)", isMultiline: true)
                }
                .padding(.xl)
            }

            MainButton(text: "Submit Report", type: .action) {
                
            }
            .padding(.horizontal, .xl)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.loadRecording()
                print("Active")
            }
        }
    }
}

#Preview {
    ReportView(viewModel: .init(form: PreviewHelper.mockReportForm, appState: AppStateManager()))
}
