//
//  PagedTabView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 13.11.2023.
//

import SwiftUI

struct PagedTabView: View {

    // MARK: - Properties

    @Binding
    var selectedTab: Int
    @Namespace
    var namespace

    var tabs: [String]

    // MARK: - Body

    var body: some View {

        HStack {

            ForEach(Array(zip(tabs.indices, tabs)), id: \.0) { tab, title in
                PagedTabViewItem(selectedTab: $selectedTab, title: title, tab: tab, namespace: namespace.self)
            }
        }
        .background(.white)
        .padding([.top, .horizontal], .xl)
    }
}

// MARK: - Preview

#Preview {
    PagedTabView(selectedTab: .constant(0), tabs: ["First", "Second"])
}
