//
//  DataHandlingView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 15.11.2023.
//

import SwiftUI

struct DataHandlingView: View {

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

            Text("Data Handling")
                .font(.heading3)
                .foregroundStyle(.text)

            VStack(spacing: .m) {

                MainButton(text: "Download My Data", type: .secondary) {
                }
                MainButton(text: "Delete My Data", type: .secondary) {
                }
            }

            Spacer()
        }
        .padding(.l)
    }
}

#Preview {
    DataHandlingView()
}
