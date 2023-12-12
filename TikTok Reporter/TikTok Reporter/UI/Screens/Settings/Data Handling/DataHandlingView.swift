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

                MainButton(text: Strings.deleteTitle, type: .secondary) {
                    viewModel.requestDataDelete()
                }
            }

            Spacer()
        }
        .padding(.l)
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
}
