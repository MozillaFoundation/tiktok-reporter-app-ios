//
//  MainButton.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 31.10.2023.
//

import SwiftUI

enum ButtonType {
    case primary
    case secondary
    case action
    
    var backgroundColor: Color {
        switch self {
        case .primary:
            return .control
        case .secondary:
            return .invertedText
        case .action:
            return .basicRed
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary:
            return .invertedText
        case .secondary:
            return .text
        case .action:
            return .invertedText
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary:
            return backgroundColor
        case .secondary:
            return foregroundColor
        case .action:
            return backgroundColor
        }
    }
}

struct MainButton: View {
    
    // MARK: - Public Properties
    
    @State
    var text: String = ""
    @State
    var type: ButtonType = .primary
    @State
    var action: () -> ()
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action, label: {
            ZStack {
                Rectangle()
                    .foregroundStyle(type.backgroundColor)
                    .border(type.borderColor, width: 2)
                Text(text)
                    .font(.body3)
                    .foregroundStyle(type.foregroundColor)
            }
        })
        .frame(height: 40.0)
    }
}
