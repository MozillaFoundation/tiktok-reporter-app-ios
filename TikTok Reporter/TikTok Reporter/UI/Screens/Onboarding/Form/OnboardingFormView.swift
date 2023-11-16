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
    
    @FocusState
    var inFocus: Int?
    
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
        VStack {
            emailView
            buttons
        }
    }
    
    private var emailView: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                FormView(viewModel: .init(form: viewModel.form))
                    .padding(.l)
                    .onChange(of: inFocus) { id in
                        withAnimation {
                            scrollView.scrollTo(id)
                        }
                    }
            }
        }
    }
    
    private var buttons: some View {
        VStack(spacing: .m) {
            MainButton(text: "Save", type: .primary) {
                // TODO: - Add upload to Glean once integrated.
                viewModel.saveData()
            }
            
            MainButton(text: "Skip", type: .secondary) {
                
            }
        }
        .padding(.l)
    }
}

#Preview {
    OnboardingFormView(viewModel: .init(appState: AppStateManager(), form: PreviewHelper.mockOnboardingForm))
}
