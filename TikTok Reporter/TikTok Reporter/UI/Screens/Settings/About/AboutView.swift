//
//  AboutView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 14.11.2023.
//

import SwiftUI

struct AboutView: View {

    // MARK: - Body

    var body: some View {

        self.content
            .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Views

    private var content: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: .xl) {
                Text("About FYP Reporter")
                    .font(.heading3)
                    .foregroundStyle(.text)

                Text((try? AttributedString(styledMarkdown: Strings.aboutMarkdown)) ?? AttributedString())
                    .font(.body2)
                    .tint(.blue)
                    .foregroundStyle(.text)
            }
            .padding(.l)
        }
    }
}

#Preview {
    AboutView()
}


// MARK: - Strings

private enum Strings {
    static let aboutMarkdown = "FYP Reporter is a tool that enables crowdsourced investigations into TikTok. It’s built by the nonprofit Mozilla. By using the app, you can participate in studies scrutinizing TikTok’s FYP algorithm. You’ll contribute to cutting-edge public interest research, which Mozilla uses to drive better public policy around tech platforms, advocate for greater transparency, and inform meaningful design interventions.\n\n FYP Reporter research participants can share videos and other TikTok content they encounter with Mozilla, providing context and comments about the content. Participants can also share screen recordings of their TikTok sessions with Mozilla. Learn more in our [privacy policy](https://foundation.mozilla.org/en/fyp-reporter/privacy-notice/)."
}
