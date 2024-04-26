//
//  DataHandlingView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 15.11.2023.
//

import SwiftUI

struct DataHandlingView: View {

    // MARK: - Properties

    @StateObject
    var viewModel: ViewModel
    @State var requestEmailScreen = false

    var emailFormView: OnboardingFormView

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        emailFormView = OnboardingFormView(
            viewModel: .init(appState: viewModel.appState, form: viewModel.form!, location: .dataHandling))
    }

    // MARK: - Body

    var body: some View {

        self.content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(.header)
                }
            }
    }

    // MARK: -  Views

    private var content: some View {

        VStack(alignment: .leading, spacing: .xl) {

            Text(Strings.title)
                .font(.heading3)
                .foregroundStyle(.text)

            VStack(spacing: .m) {
                if emailFormView.viewModel.isDataDownloaded || viewModel.isDataDownloaded {
                    downloadDataView
                } else {
                    if viewModel.canRequestDataDownload() {
                        MainButton(text: Strings.downloadTitle, type: .secondary) {
                            viewModel.requestDataDownload()
                        }
                    } else {
                        NavigationLink(
                            destination: emailFormView,
                            isActive: $viewModel.routing.requestEmailScreen
                        ) {
                            MainButton(text: Strings.downloadTitle, type: .secondary) {
                                viewModel.requestEmailForDataDownload()
                            }
                        }
                    }
                }

                if !viewModel.isUserDataDeleted {
                    MainButton(text: Strings.deleteTitle, type: .secondary) {
                        viewModel.requestDataDelete()
                    }
                }
                
                if viewModel.isUserDataDeleted {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Image(systemName: "checkmark")
                                .renderingMode(.template)
                                .foregroundColor(.success)
                            
                            Text(Strings.dataDeletionTitle)
                                .foregroundStyle(Color.success)
                                .font(.body3)
                            
                            Spacer()
                        }
                    }.padding(.top, 5)
                }

            }

            Spacer()
        }
        .padding(.l)
        .customAlert(title: Strings.deleteDataAlertTitle,
                     description: Strings.deleteDataAlertDescription,
                     isPresented: $viewModel.routing.deleteDataAlert,
                     secondaryButton: {
            MainButton(text: Strings.deleteDataAlertSecondaryActionTitle, type: .secondary) {
                viewModel.routing.deleteDataAlert = false
            }
        }, primaryButton: {
            MainButton(text: Strings.deleteDataAlertPrimaryActionTitle, type: .primary) {
                viewModel.routing.deleteDataAlert = false
                viewModel.deleteUserData()
            }
        }).onDisappear {
            emailFormView.viewModel.isDataDownloaded = false
            viewModel.isDataDownloaded = false
        }
    }
    
    private var downloadDataView: some View {
        VStack {
            HStack(alignment: .top) {
                Spacer()
                
                Image(systemName: "checkmark")
                    .renderingMode(.template)
                    .foregroundColor(.success)
                    .padding(.top, 5)
                
                Text(Strings.dataDownloadedTitle)
                    .foregroundStyle(Color.success)
                    .font(.body3)
                
                Spacer()
            }
        }.padding(.top, 5)
    }
}

// MARK: - Preview

#Preview {
    DataHandlingView(viewModel: .init(appState: AppStateManager()))
}

// MARK: - Strings

private enum Strings {
    static let title = "Manage Your Data"
    static let downloadTitle = "Download Your Data"
    static let deleteTitle = "Delete Your Data"
    static let deleteDataAlertTitle = "Delete Data?"
    static let deleteDataAlertDescription = "Are you sure you want to delete all your data from our system?"
    static let deleteDataAlertPrimaryActionTitle = "Delete"
    static let deleteDataAlertSecondaryActionTitle = "No"
    static let dataDeletionTitle = "Data Succesfully Deleted"
    static let dataDownloadedTitle = "Your request has been received. An email containing your data will be sent shortly"
}
