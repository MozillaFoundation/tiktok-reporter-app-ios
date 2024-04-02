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

    @State
    var isPresentedFromShareExtension: Bool = false
    
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

                    Text(Strings.title)
                        .font(.body5)
                        .foregroundStyle(.success)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }

            MainButton(text: Strings.buttonTitle, type: .secondary) {
                self.isPresented = false
                
                
                if isPresentedFromShareExtension {
                    postCloseNotificationForShareExt()
                }
            }
        }
        .padding(.horizontal, .xl)
    }
}

private extension SubmissionSuccessView {
    func postCloseNotificationForShareExt() {
        NotificationCenter
            .default
            .post(
                name: NSNotification.Name(Strings.closeNotificationName),
                object: nil,
                userInfo: [
                    "success": true
                ])
    }
}

// MARK: - Preview

#Preview {
    SubmissionSuccessView(isPresented: .constant(true))
}

// MARK: - Strings

private enum Strings {
    static let title = "Thank you!\nReport submitted."
    static let buttonTitle = "I'm done"
    static let settingDescription = "To receive a copy of your report on your email and to get follow up information about our study, go to "
    static let settingButtonTitle = "Settings"
    static let settingActionNotificationName = "settingDidClicked"
    
    static let closeNotificationName = "close"
}
