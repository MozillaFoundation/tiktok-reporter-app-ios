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

    @State
    var alertType: AlertType = .info(title: "", description: "")
    @State
    var rightButtonAction: (() -> ())?

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .center) {

            Color.black
                .opacity(0.5)
                .ignoresSafeArea()

            VStack(spacing: .xl) {

                Text(alertType.title)
                    .font(.heading5)
                    .foregroundStyle(.text)
                    .padding(.top, .xl)

                Text(alertType.description)
                    .font(.body2)
                    .foregroundStyle(.text)

                HStack(spacing: .l) {
                    MainButton(text: alertType.leftButtonTitle, type: .secondary) {
                        isPresented = false
                    }

                    if let rightButtonTitle = alertType.rightButtonTitle, let buttonAction = rightButtonAction {
                        MainButton(text: rightButtonTitle, type: .primary, action: buttonAction)
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
    AlertView(isPresented: .constant(true), alertType: .action(title: "Title", description: "Description", leftButtonTitle: "Keep", rightButtonTitle: "Proceed"), rightButtonAction: {})
}
