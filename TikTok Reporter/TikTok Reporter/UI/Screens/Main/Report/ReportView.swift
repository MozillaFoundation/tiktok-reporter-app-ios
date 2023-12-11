//
//  ReportView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 13.11.2023.
//

import SwiftUI

struct ReportView: View {

    // MARK: - Properties

    @StateObject
    var viewModel: ViewModel

    // MARK: - Body

    var body: some View {

        PresentationStateView(viewModel: viewModel) {
            self.content
        }
    }

    // MARK: - Views

    @ViewBuilder
    private var content: some View {

        if viewModel.routingState.submissionResult {

            SubmissionSuccessView(isPresented: $viewModel.routingState.submissionResult)
        } else {

            VStack {
                
                FormView(viewModel: .init(formUIContainer: $viewModel.formUIContainer, didUpdateMainField: $viewModel.didUpdateMainField))
                
                VStack {
                    
                    MainButton(text: Strings.submitTitle, type: .action) {

                        viewModel.sendReport()
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
}

// MARK: - Preview

#Preview {
    ReportView(viewModel: .init(form: PreviewHelper.mockReportForm, appState: AppStateManager()))
}

// MARK: - Strings

private enum Strings {
    static let submitTitle = "Submit Report"
    static let cancelTitle = "Cancel Report"
}
