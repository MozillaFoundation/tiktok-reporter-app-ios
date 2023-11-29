//
//  ErrorView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 29.11.2023.
//

import SwiftUI

struct ErrorView: View {

    // MARK: - Properties

    @Binding
    var shouldReload: Bool

    // MARK: - Body

    var body: some View {
        
        ZStack {
            ZStack(alignment: .center) {
                
                VStack(spacing: .xl) {

                    Image(.error)

                    Text("Ups! Something went wrong")
                        .font(.heading3)
                        .foregroundStyle(.text)

                    Text("The system doesn’t seem to respond. Our cat must have been chewing the wires again.")
                        .font(.heading5)
                        .foregroundStyle(.text)
                        .multilineTextAlignment(.center)

                    Text("Please forgive Tom and try again later.")
                        .font(.heading5)
                        .foregroundStyle(.text)
                        .multilineTextAlignment(.center)
                }
                .padding(.xl)
            }

            VStack {
                Spacer()
                MainButton(text: "Refresh", type: .secondary) {
                    shouldReload = true
                }
                .padding(.horizontal, .xl)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ErrorView(shouldReload: .constant(false))
}
