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

            
            if !isPresentedFromShareExtension {
                
                VStack(alignment: .leading) {
                    Text(Strings.settingDescription)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.body2)
                        .foregroundStyle(.disabled)

                    NavigationLink {
                        EmptyView()
                    } label: {
                        HStack {
                            Button(action: {
                                NotificationCenter.default.post(name: NSNotification.Name(Strings.settingActionNotificationName), object: nil)
                            }) {
                                Text(Strings.settingButtonTitle)
                                    .foregroundColor(.basicRed)
                                    .font(.body2)
                                    .underline()
                            }
                        }
                    }
                    
                    
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
    static let description = "To receive a copy of your report on your email and to get follow up information about our study, go to Settings"
    static let buttonTitle = "I'm done"
    static let settingDescription = "To receive a copy of your report on your email and to get follow up information about our study, go to "
    static let settingButtonTitle = "Settings"
    static let settingActionNotificationName = "settingDidClicked"
    
    static let closeNotificationName = "close"
}
