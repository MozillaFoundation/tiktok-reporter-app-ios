//
//  LimitCharacters.swift
//  TikTok Reporter
//
//  Created by Emrah Korkmaz on 25.01.2024.
//

import SwiftUI

struct LimitCharacters: ViewModifier {
    @Binding var text: String
    var limit: Int
    var isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .onReceive(text.publisher.collect()) {
                if isEnabled, text.count > limit {
                    self.text = String($0.prefix(limit))
                    return
                }
            }
    }
}

extension View {
    func limitCharacters(_ text: Binding<String>, limit: Int, isEnabled: Bool) -> some View {
        self.modifier(LimitCharacters(text: text, limit: limit, isEnabled: isEnabled))
    }
}

