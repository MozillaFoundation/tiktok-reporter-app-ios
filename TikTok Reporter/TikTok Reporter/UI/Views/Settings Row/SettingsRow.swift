//
//  SettingsRow.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 13.11.2023.
//

import SwiftUI

struct SettingsRow: View {
    
    // MARK: - Properties
    
    var title: String
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: .xl) {
            HStack {
                Text(title)
                    .font(.body2)
                    .foregroundStyle(.text)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.text)
            }
            
            Color.divider
                .frame(height: 2.0)
        }
        .padding(.horizontal, .l)
        .frame(height: 72.0)
    }
}

#Preview {
    SettingsRow(title: "ROW")
}
