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
                
                FormView(formInputContainer: $viewModel.formInputContainer,
                         didUpdateMainField: $viewModel.didUpdateMainField,
                         shouldScrollToNonValidatedContext: $viewModel.formShouldScrollToNotValidatedScope)
                
                VStack {
                    
                    MainButton(text: Strings.submitTitle, type: .action) {

                        viewModel.sendReport()
                    }
                    
                    if viewModel.didUpdateMainField {

                        MainButton(text: Strings.cancelTitle, type: .secondary) {
                            viewModel.routingState.alert = true
                        }
                    }
                }
                .padding(.horizontal, .xl)
            }
            .onChange(of: viewModel.formShouldScrollToNotValidatedScope) { newValue in
                guard newValue else { return }
                viewModel.formShouldScrollToNotValidatedScope = false
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
                        viewModel.routingState.alert = false
                        viewModel.cancelReport()
                    }
                }
            )
            
            
            
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
    static let cancelReportAlertTitle = "Cancel Report?"
    static let cancelReportAlertDescription = "Are you sure you want to cancel the report? All the data entered will be deleted"
    static let cancelReportAlertPrimaryButtonTitle = "Delete"
    static let cancelReportAlertSecondaryButtonTitle = "Keep"
}
