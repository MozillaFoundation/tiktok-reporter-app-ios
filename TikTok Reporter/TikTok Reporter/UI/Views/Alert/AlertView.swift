//
//  AlertView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 31.10.2023.
//

import SwiftUI

struct AlertView: View {

    // MARK: - Private Properties

    @Binding
    var isPresented: Bool

    var title: String
    var description: String
    var secondaryButton: () -> MainButton
    var primaryButton: (() -> MainButton)?

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .center) {

            Color.black
                .opacity(0.5)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: .xl) {

                Text(title)
                    .font(.heading5)
                    .foregroundStyle(.text)
                    .padding([.top, .horizontal], .xl)

                Text(description)
                    .font(.body2)
                    .foregroundStyle(.text)
                    .padding(.horizontal, .xl)

                HStack(spacing: .l) {
                    secondaryButton()

                    if let primaryButton = primaryButton {
                        primaryButton()
                    }
                }
                .padding([.horizontal, .bottom], .xl)
            }
            .background(.invertedText)
            .padding(.xl)
        }
    }
}

#Preview {
    AlertView(isPresented: .constant(true), title: "Title", description: "Description", secondaryButton: { MainButton() {} })
}
