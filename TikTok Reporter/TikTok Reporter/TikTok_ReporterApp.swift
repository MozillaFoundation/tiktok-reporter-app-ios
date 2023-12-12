//
//  TikTok_ReporterApp.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 27.10.2023.
//

import SwiftUI

@main
struct TikTok_ReporterApp: App {

    // MARK: - State

    @State
    private var isActive: Bool = false

    // MARK: - Body

    var body: some Scene {

        WindowGroup {

            if isActive {

                ContentView()
                    .onAppear {
                        UITextView.appearance().backgroundColor = .clear
                        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backImage")
                        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backImage")
                        UINavigationBar.appearance().tintColor = UIColor(named: "text")
                    }
            } else {
                SplashScreen(isActive: $isActive)
            }
        }
    }
}

extension UINavigationController {

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }
}
