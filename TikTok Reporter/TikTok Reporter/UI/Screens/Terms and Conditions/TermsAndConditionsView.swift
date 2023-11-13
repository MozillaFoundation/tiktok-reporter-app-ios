//
//  TermsAndConditionsView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 31.10.2023.
//

import SwiftUI

struct TermsAndConditionsView: View {
    
    // MARK: - Properties

    @ObservedObject
    var viewModel: ViewModel
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            PresentationStateView(viewModel: self.viewModel) {
                self.content
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image(.header)
                    }
                }
            }
            .customAlert(
                alertType: .info(title: "Review the terms & conditions", description: "Please read these terms and conditions carefully before using TikTok Reporter."),
                isPresented: $viewModel.routingState.alert
            )
        }
    }
    
    // MARK: - Views

    private var content: some View {
        VStack {
            textContentView
            buttonContainerView
        }
    }
    
    private var textContentView: some View {

        ScrollView {
            
            VStack(alignment: .leading, spacing: .xl) {

                Text(viewModel.termsOfService?.title ?? "")
                    .font(.heading3)
                    .foregroundStyle(.text)

                VStack(alignment: .leading, spacing: .l) {

                    Text(viewModel.termsOfService?.subtitle ?? "")
                        .font(.heading5)
                        .foregroundStyle(.text)
                    Text(viewModel.termsOfService?.text ?? "")
                        .font(.body2)
                        .foregroundStyle(.text)
                }
            }
            .padding(.xl)
        }
    }
    
    private var buttonContainerView: some View {
        VStack(spacing: .m) {

            MainButton(text: "I Agree", type: .primary, action: {
                viewModel.showStudiesScreen()
            })
            MainButton(text: "I Disagree", type: .secondary, action: {

                withAnimation(.spring) {
                    viewModel.showAlert()
                }
            })
        }
        .padding([.horizontal, .bottom], .xl)
    }
}

#Preview {
    TermsAndConditionsView(viewModel: .init(appState: AppStateManager()))
}
