//
//  ContentView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 27.10.2023.
//

import SwiftUI

struct ContentView: View {
    @State
    var isPresented: Bool = false

    var body: some View {
        NavigationView {
            TermsAndConditionsView(viewModel: .init())
        }
    }
}

#Preview {
    ContentView()
}
