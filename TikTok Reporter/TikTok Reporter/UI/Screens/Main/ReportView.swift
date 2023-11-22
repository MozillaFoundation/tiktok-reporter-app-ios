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
        Text("Tab Content 2")
    }
}

#Preview {
    ReportView(viewModel: .init(form: PreviewHelper.mockReportForm, appState: AppStateManager()))
}
