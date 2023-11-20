//
//  View+Keyboard.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 20.11.2023.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
