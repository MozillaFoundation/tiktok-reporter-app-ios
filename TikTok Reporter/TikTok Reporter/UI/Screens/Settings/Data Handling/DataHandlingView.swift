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

                MainButton(text: Strings.downloadTitle, type: .secondary) {
                    
                    viewModel.requestDataDownload()
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
        .customAlert(title: Strings.noEmailAlertTitle,
                     description: Strings.noEmailAlertDescription,
                     isPresented: $viewModel.routing.noEmailAlert) {
            MainButton(text: Strings.noEmailAlertActionTitle, type: .secondary) {
                viewModel.routing.noEmailAlert = false
            }
        }
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
        })
    }
}

// MARK: - Preview

#Preview {
    DataHandlingView(viewModel: .init(appState: AppStateManager()))
}

// MARK: - Strings

private enum Strings {
    static let title = "Data Handling"
    static let downloadTitle = "Download My Data"
    static let deleteTitle = "Delete My Data"
    static let noEmailAlertTitle = "No email provided"
    static let noEmailAlertDescription = "Please provide an email in order to get a copy of your data."
    static let noEmailAlertActionTitle = "Got it"
    static let deleteDataAlertTitle = "Delete Data?"
    static let deleteDataAlertDescription = "Are you sure you want to delete all your data from the system?"
    static let deleteDataAlertPrimaryActionTitle = "Delete"
    static let deleteDataAlertSecondaryActionTitle = "No"
    static let dataDeletionTitle = "Data Succesfully Deleted"
}
