//
//  CustomAlertModifier.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 31.10.2023.
//

import SwiftUI

struct CustomAlertModifier: ViewModifier {

    // MARK: - Properties

    @State
    var alertType: AlertType = .info(title: "", description: "")

    @Binding
    var isPresented: Bool
    
    // MARK: - Methods

    func body(content: Content) -> some View {
        ZStack() {
            content
            if isPresented {
                AlertView(isPresented: $isPresented, alertType: alertType)
            }
        }
    }
}

extension View {
    func customAlert(alertType: AlertType, isPresented: Binding<Bool>) -> some View {
        modifier(CustomAlertModifier(alertType: alertType, isPresented: isPresented))
    }
}
