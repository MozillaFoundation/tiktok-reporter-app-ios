//
//  MainView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 07.12.2023.
//

import SwiftUI

struct MainView: View {

    // MARK: - Properties

    @StateObject
    var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        
        self.content
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

            PagedTabView(
                selectedTab: $viewModel.selectedTab,
                tabs: viewModel.tabs.compactMap { $0.tabTitle }
            )
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

    private var reportTab: some View {

        ReportView(viewModel: .init(form: viewModel.form, appState: viewModel.appState))
    }

    private var recordTab: some View {

        RecordView(viewModel: .init(appState: viewModel.appState))
    }
}
