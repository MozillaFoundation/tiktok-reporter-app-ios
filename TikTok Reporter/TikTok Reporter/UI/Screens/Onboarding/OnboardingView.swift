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
        
//        NavigationView {
            self.content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            Image(.header)
                        }
                    }
                }
//        }
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
            ForEach(viewModel.steps, id: \.self) { step in
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

            if viewModel.currentStep < viewModel.steps.count - 1 {
                MainButton(text: "Skip", type: .secondary) {
                    viewModel.finishOnboarding()
                }
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
    OnboardingView(viewModel: .init(appState: AppStateManager(), onboarding: PreviewHelper.mockOnboarding))
}
