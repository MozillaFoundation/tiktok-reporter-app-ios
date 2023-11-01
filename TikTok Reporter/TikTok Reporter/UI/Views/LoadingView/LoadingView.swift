//
//  LoadingView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
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
            Text("Loading TikTok Reporter...")
                .font(.heading5)
        }
    }
}

#Preview {
    LoadingView()
}
