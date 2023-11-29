//
//  EmptyView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 10.11.2023.
//

import SwiftUI

struct IdleView: View {

    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(spacing: .xl) {

                Image(.empty)

                Text(Strings.title)
                    .font(.heading3)
                    .foregroundStyle(.text)

                Text(Strings.description)
                    .font(.heading5)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.text)
            }
            .padding(.xxl)
        }
    }
}

// MARK: - Preview

#Preview {
    IdleView()
}

// MARK: - Strings

private enum Strings {
    static let title = "No studies available"
    static let description = "We are sorry to announce that there are no studies available for your location.\n\n Come back at a later date to check if any new study has been opened."
}
