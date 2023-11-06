//
//  OnboardingView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 04.11.2023.
//

import SwiftUI

struct OnboardingView: View {
    
    // MARK: - Properties
    
    @ObservedObject
    var viewModel: ViewModel
    
    @State
    private var buttonStackHeight: CGFloat = 0.0
    
    // MARK: - Body
    
    var body: some View {
        
        NavigationView {
            self.content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // Temporary until we receive logo from Mozilla.
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            Image(systemName: "play.rectangle")
                            Text("TikTok Reporter").font(.heading5)
                        }
                    }
                }
        }
    }
    
    // MARK: - Views
    
    private var content: some View {
        ZStack {
            pageView
            VStack {
                Spacer()
                buttons
                    .background(.white)
            }
        }
    }
    
    private var pageView: some View {

        TabView(selection: $viewModel.currentStep) {
            ForEach(viewModel.onboarding.steps, id: \.self) { step in
                OnboardingPageView(onboardingStep: step, contentInset: $buttonStackHeight)
                    .gesture(DragGesture())
                    .tag(viewModel.index(of: step))
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    private var buttons: some View {

        VStack(spacing: .m) {
            MainButton(text: "Next", type: .primary) {
                viewModel.nextStep()
            }
            
            if viewModel.currentStep > 0 {
                MainButton(text: "Back", type: .secondary) {
                    viewModel.previousStep()
                }
            }
            
            MainButton(text: "Skip", type: .secondary) {
                
            }
        }
        .padding(.xl)
        .background {
            // Solution chosen to simulate a `contentInset` on the ScrollView.
            GeometryReader { reader in
                self.buttonStackHeight = reader.size.height
                return Color.clear
            }
        }
    }
}

#Preview {
    OnboardingView(viewModel: .init(onboarding: Onboarding(id: "", name: "Onboarding", steps: [], form: nil)))
}
