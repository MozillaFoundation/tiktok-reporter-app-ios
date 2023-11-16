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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(.header)
                }
            }
    }

    // MARK: - Views

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .xl) {
                Text("About TikTok Reporter")
                    .font(.heading3)
                    .foregroundStyle(.text)

                Text("“TikTok Repoter” serves as a vital tool in an ongoing sociological study, seeking to understand the broader implications of content shared on TikTok. By reporting harmful videos, users contribute to a wealth of data that will be instrumental in identifying and addressing the social issues, influences, and trends within the platform.\n\n Join us in shaping the future of digital interaction by participating in this sociological study through “TikTok Repoter” Your reports make a difference in the quest to foster a safer, more informed, and socially conscious digital environment.\n\n Anonymous Reporting: SocialSafeguard ensures users can report troubling TikTok content discreetly, preserving their privacy.\n\n Categorization: Users can categorize the type of harm observed in videos, such as bullying, misinformation, hate speech, or other sociological factors.\n\n Commentary: The app allows users to provide context and insights, fostering a deeper understanding of the content’s impact.\n\n Data Collection: Reports are collated into a comprehensive database, allowing sociologists to analyze and identify trends and patterns.")
                    .font(.body2)
                    .foregroundStyle(.text)
            }
            .padding(.l)
        }
    }
}

#Preview {
    AboutView()
}

