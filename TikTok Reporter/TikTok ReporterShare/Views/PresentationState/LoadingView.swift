//
//  LoadingView.swift
//  TikTok ReporterShare
//
//  Created by Sergiu Ghiran on 21.11.2023.
//

import SwiftUI

struct LoadingView: View {

    // MARK: - Body

    var body: some View {

        VStack(spacing: .xxl) {

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2.0, anchor: .center)
                .tint(.basicRed)

            Text(Strings.loading)
                .font(.heading5)
        }
    }
}

// MARK: - Preview

#Preview {
    LoadingView()
}

// MARK: - Strings

private enum Strings {
    static let loading = "Loading TikTok Reporter..."
}
