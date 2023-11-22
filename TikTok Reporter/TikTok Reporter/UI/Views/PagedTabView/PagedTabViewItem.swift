//
//  PagedTabViewItem.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 13.11.2023.
//

import SwiftUI

struct PagedTabViewItem: View {
    
    // MARK: - Properties
    
    @Binding
    var selectedTab: Int
    
    var title: String
    var tab: Int
    
    let namespace: Namespace.ID
    
    // MARK: - Body
    
    var body: some View {
        
        Button(action: {
            withAnimation {
                selectedTab = tab
            }
        }, label: {
            VStack {
                Text(title)
                    .font(.body3)
                    .foregroundStyle(selectedTab == tab ? .text : .disabled)
                if selectedTab == tab {
                    Capsule()
                        .foregroundStyle(.basicRed)
                        .frame(height: 4.0)
                        .matchedGeometryEffect(
                            id: "Tab",
                            in: namespace,
                            properties: .frame
                        )
                } else {
                    Color.clear
                        .frame(height: 4.0)
                }
            }
        })
        .animation(.spring, value: selectedTab)
    }
}

// MARK: - Preview

//#Preview {
//    PagedTabViewItem(selectedTab: .constant(0), title: "Report a link", tab: 0)
//}
