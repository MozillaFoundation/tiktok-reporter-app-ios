//
//  MainTextField.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 06.11.2023.
//

import SwiftUI

enum MainTextFieldType {
    case standard
    case email

    var autocapitalization: TextInputAutocapitalization {
        switch self {
        case .standard:
            return .words
        case .email:
            return .never
        }
    }

    var keyboardType: UIKeyboardType {
        switch self {
        case .standard:
            return .default
        case .email:
            return .emailAddress
        }
    }
}

struct MainTextField: View {

    // MARK: - Properties

    @Binding
    var text: String
    var placeholder: String
    var type: MainTextFieldType = .standard

    @State
    var opacity: CGFloat = 0.0

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .leading) {
            textField
                .padding(.vertical, .s)
            placeholderView
                .padding(.leading, .s)
        }
        .frame(height: 56.0)
    }

    // MARK: - Views

    private var textField: some View {
        TextField(placeholder, text: _text)
            .textInputAutocapitalization(type.autocapitalization)
            .keyboardType(type.keyboardType)
            .font(.heading4)
            .padding(.m)
            .background {
                Rectangle()
                    .stroke(.text)
            }
    }

    private var placeholderView: some View {
        VStack {
            Text(placeholder)
                .font(.body2)
                .padding(.horizontal, .xs)
                .background(.white)
                .opacity(opacity)
                .onChange(of: text) { newValue in
                    withAnimation {
                        opacity = newValue.isEmpty ? 0.0 : 1.0
                    }
                }
            Spacer()
        }
    }
}

#Preview {
    MainTextField(text: .constant(""), placeholder: "Placeholder")
}
