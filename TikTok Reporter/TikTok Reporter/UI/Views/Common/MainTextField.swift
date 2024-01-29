//
//  MainTextField.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 06.11.2023.
//

import SwiftUI

struct MainTextField: View {
    
    // MARK: - Properties
    
    @Binding
    var text: String
    @Binding
    var isValid: Bool
    @Binding
    var isEnabled: Bool

    var placeholder: String
    var isMultiline: Bool
    
    @State
    var isTikTokLink: Bool = false
    
    @State
    var opacity: CGFloat = 0.0
    
    @State
    private var limitCount = 500
    
    @State
    var isLimitEnabled: Bool = true
    
    // MARK: - Body
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            ZStack(alignment: .leading) {
                
                if isMultiline {
                    multilineTextField
                } else {
                    textField
                        .onChange(of: text) { _ in
                            guard isTikTokLink else {
                                isValid = true
                                return
                            }
                            
                            isValid = validateTikTokLink(linkURL: text)
                        }
                }
                
                placeholderView
                    .padding(.leading, .s)
            }
        }
    }
    
    // MARK: - Views
    
    private var textField: some View {
        
        VStack {
            TextField(placeholder, text: $text)
                .font(.body1)
                .padding(.m)
                .frame(height: 40.0)
                .border(isValid ? .text : .error, width: isEnabled ? 1.0 : 1.0)
                .padding(.top, .s)
                .disabled(!isEnabled)
                .limitCharacters($text, limit: 500, isEnabled: isLimitEnabled)
            
            if isLimitEnabled {
                textFieldCharacterCountView
            }
        }
    }
    
    @ViewBuilder
    private var multilineTextField: some View {
        
        VStack {
            
            if #available(iOS 16, *) {
                
                TextEditor(text: $text)
                    .font(.body1)
                    .padding(.horizontal, .s)
                    .padding(.vertical, .xs)
                    .frame(minHeight: 104.0)
                    .border(.text, width: 1.0)
                    .scrollContentBackground(.hidden)
                    .background {
                        editorBackground
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, .s)
                    .limitCharacters($text, limit: 500, isEnabled: isLimitEnabled)
            } else {
                
                TextEditor(text: $text)
                    .font(.body1)
                    .padding(.horizontal, .s)
                    .padding(.vertical, .xs)
                    .frame(minHeight: 104.0)
                    .border(.text, width: 1.0)
                    .background {
                        editorBackground
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, .s)
                    .limitCharacters($text, limit: 500, isEnabled: isLimitEnabled)
            }
            
            if isLimitEnabled {
                textFieldCharacterCountView
            }
        }
    }
    
    private var placeholderView: some View {
        
        VStack {
            Text(placeholder)
                .font(.body2)
                .padding(.horizontal, .xs)
                .background(.white)
                .opacity(text.isEmpty ? 0.0 : 1.0)
                .onChange(of: text) { newValue in
                    withAnimation {
                        opacity = newValue.isEmpty ? 0.0 : 1.0
                    }
                }
                .limitCharacters($text, limit: 500, isEnabled: isLimitEnabled)
            Spacer()
        }
    }
    
    private var textFieldCharacterCountView: some View {
        HStack {
            if !isValid {
                Text(generateTikTokValidationErrorMessage())
                    .font(.body2)
                    .foregroundStyle(.error)
                    .padding(.top, 5)
            }
            Spacer()
            Text("\(text.count)/\(limitCount)")
                .font(.caption)
        }
        .foregroundStyle(Color.black)
    }
    
    private var editorBackground: some View {

        VStack {
            HStack {
                Text(placeholder)
                    .font(.body1)
                    .foregroundStyle(text.isEmpty ? .disabled : .clear)
                Spacer()
            }
            Spacer()
        }
        .padding(.m)
    }
    
    func validateTikTokLink(linkURL: String) -> Bool {
        guard let tiktokUrlComponents = URLComponents(string: linkURL),
              let tiktokURLHost = tiktokUrlComponents.host else {
            isValid = false
            return false
        }
        
        let isValid = Strings.validTikTokLinks.contains(where: { $0 == tiktokURLHost })
        return isValid
    }
    
    func generateTikTokValidationErrorMessage() -> String {
        guard isTikTokLink else {
            return Strings.errorMessage
        }
        return Strings.notValidatedURLErrorMessage
    }
}

// MARK: - Preview

#Preview {
    MainTextField(text: .constant(""), isValid: .constant(true), isEnabled: .constant(true), placeholder: "Placeholder", isMultiline: true)
}

// MARK: - Strings

private enum Strings {
    static let errorMessage = "This field cannot be empty"
    static let notValidatedURLErrorMessage = "Please paste a TikTok link"
    static let validTikTokLinks = ["tiktok.com", "www.tiktok.com", "vm.tiktok.com"]
}
