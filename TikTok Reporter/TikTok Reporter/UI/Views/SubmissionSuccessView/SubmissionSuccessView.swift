//
//  SubmissionSuccessView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 29.11.2023.
//

import SwiftUI

struct SubmissionSuccessView: View {

    // MARK: - Properties

    @Binding
    var isPresented: Bool

    // MARK: - Body

    var body: some View {

            self.content
    }

    // MARK: - Views

    private var content: some View {

        VStack(spacing: .l) {

            ZStack(alignment: .center) {

                VStack(alignment: .center, spacing: .xl) {

                    Spacer()
                    Image(.success)

                    Text("Thank you!\nReport submitted.")
                        .font(.body5)
                        .foregroundStyle(.success)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }

            MainButton(text: "I'm done", type: .secondary) {
                self.isPresented = false
            }
            Text("To receive a copy of your report on your email and to get follow up information about our study, go to Settings")
                .font(.body2)
                .foregroundStyle(.disabled)
        }
        .padding(.horizontal, .xl)
    }
}

// MARK: - Preview

#Preview {
    SubmissionSuccessView(isPresented: .constant(true))
}
