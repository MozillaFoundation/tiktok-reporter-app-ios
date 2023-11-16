//
//  CustomAlertModifier.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 31.10.2023.
//

import SwiftUI

struct CustomAlertModifier: ViewModifier {

    // MARK: - Properties

    var title: String
    var description: String
    
    @Binding
    var isPresented: Bool
    
    var secondaryButton: () -> MainButton
    var primaryButton: (() -> MainButton)?
    
    // MARK: - Methods

    func body(content: Content) -> some View {
        ZStack() {
            content
            if isPresented {
                AlertView(isPresented: $isPresented, title: title, description: description, secondaryButton: secondaryButton, primaryButton: primaryButton)
            }
        }
    }
}

extension View {
    func customAlert(title: String, description: String, isPresented: Binding<Bool>, secondaryButton: @escaping () -> MainButton, primaryButton: (() -> MainButton)? = nil) -> some View {
        modifier(CustomAlertModifier(title: title, description: description, isPresented: isPresented, secondaryButton: secondaryButton, primaryButton: primaryButton))
    }
}
