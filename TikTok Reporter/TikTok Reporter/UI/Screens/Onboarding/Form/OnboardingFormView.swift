//
//  OnboardingFormView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 07.11.2023.
//

import SwiftUI

struct OnboardingFormView: View {
    
    // MARK: - Properties
    
    @ObservedObject
    var viewModel: ViewModel
    
    // MARK: - Body
    
    var body: some View {

        self.content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(.header)
                }
            }
    }
    
    // MARK: - Views
    
    private var content: some View {

        VStack {
            emailView
            buttons
        }
    }
    
    private var emailView: some View {

        ScrollViewReader { scrollView in

            ScrollView {

                // TODO: - Try to avoid re-initializing ViewModel on each re-draw
                FormView(viewModel: .init(formUIContainer: $viewModel.formUIContainer, didUpdateMainField: $viewModel.didUpdateMainField))
            }
        }
    }
    
    private var buttons: some View {
        VStack(spacing: .m) {
            if viewModel.didUpdateMainField {
                MainButton(text: "Save", type: .primary) {
                    viewModel.saveData()
                }
            }

            if viewModel.location == .onboarding {
                MainButton(text: "Skip", type: .secondary) {
                    viewModel.skip()
                }
            }
        }
        .padding(.l)
    }
}

#Preview {
    OnboardingFormView(viewModel: .init(appState: AppStateManager(), form: PreviewHelper.mockOnboardingForm))
}
