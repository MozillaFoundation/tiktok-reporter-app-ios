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

    // MARK: - Body

    var body: some View {
//        NavigationView {
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
//        }
    }

    // MARK: - Views

    private var content: some View {

        VStack {

            PagedTabView(selectedTab: $viewModel.selectedTab, tabs: viewModel.tabs)
                .background(.white)

            TabView(selection: $viewModel.selectedTab) {
                reportTab
                recordTab
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }

    private var reportTab: some View {
        
        FormView(viewModel: .init(form: viewModel.form, hasSubmit: true))
            .tag(0)
    }

    private var recordTab: some View {
        Text("Tab Content 2").tag(1)

    }
}

#Preview {
    ReportView(viewModel: .init(form: PreviewHelper.mockReportForm, appState: AppStateManager()))
}
