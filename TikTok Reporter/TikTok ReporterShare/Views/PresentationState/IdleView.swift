//
//  IdleView.swift
//  TikTok ReporterShare
//
//  Created by Sergiu Ghiran on 21.11.2023.
//

import SwiftUI

struct IdleView: View {

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: .xl) {
                Image(.empty)
                Text("No studies available")
                    .font(.heading3)
                    .foregroundStyle(.text)
                Text("We are sorry to announce that there are no studies available for your location.\n\n Come back at a later date to check if any new study has been opened.")
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
