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

                FormView(formInputContainer: $viewModel.formUIContainer, didUpdateMainField: $viewModel.didUpdateMainField)
            }
        }
    }
    
    private var buttons: some View {

        VStack(spacing: .m) {

            if viewModel.didUpdateMainField {

                MainButton(text: Strings.saveTitle, type: .primary) {
                    viewModel.saveData()
                }
            }

            if viewModel.location == .onboarding {

                MainButton(text: Strings.skipTitle, type: .secondary) {
                    viewModel.skip()
                }
            }
        }
        .padding(.l)
    }
}

// MARK: - Preview

#Preview {
    OnboardingFormView(viewModel: .init(appState: AppStateManager(), form: PreviewHelper.mockOnboardingForm))
}

// MARK: - Strings

private enum Strings {
    static let saveTitle = "Save"
    static let skipTitle = "Skip"
}
