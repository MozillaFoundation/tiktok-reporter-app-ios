//
//  SplashScreen.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 13.11.2023.
//

import SwiftUI

struct SplashScreen: View {

    // MARK: - Properties

    @Binding
    var isActive: Bool

    // MARK: - Body

    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(colors: [.basicRed, .error], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1.0, y: 0.0))
                )
            Image(.logo)
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreen(isActive: .constant(false))
}
