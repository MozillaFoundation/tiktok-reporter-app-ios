//
//  PolicyView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 31.10.2023.
//

import SwiftUI

struct PolicyView: View {
    
    // MARK: - Properties

    @ObservedObject
    var viewModel: ViewModel
    
    // MARK: - Body
    
    var body: some View {

        PresentationStateView(viewModel: self.viewModel) {
            self.content
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(.header)
            }
        }
        .navigationBarBackButtonHidden(!viewModel.appState.hasCompletedOnboarding)
        .customAlert(
            title: "Review the terms & conditions",
            description: "Please read these terms and conditions carefully before using TikTok Reporter.",
            isPresented: $viewModel.routingState.alert) {
                MainButton(text: "Got it", type: .secondary) {
                    viewModel.routingState.alert = false
                }
            }
    }
    
    // MARK: - Views

    private var content: some View {
        VStack {
            textContentView

            if viewModel.hasActions {
                buttonContainerView
            }
        }
    }
    
    private var textContentView: some View {

        ScrollView {
            
            VStack(alignment: .leading, spacing: .xl) {

                Text(viewModel.policy?.title ?? "")
                    .font(.heading3)
                    .foregroundStyle(.text)

                VStack(alignment: .leading, spacing: .l) {

                    Text(viewModel.policy?.subtitle ?? "")
                        .font(.heading5)
                        .foregroundStyle(.text)
                    
                    let policyText = (try? AttributedString(styledMarkdown: viewModel.policy?.text ?? "")) ?? AttributedString()
                    
                    Text(policyText)
                        .font(.body2)
                        .tint(.blue)
                        .foregroundStyle(.black)
                }
            }
            .padding(.xl)
        }
    }
    
    private var buttonContainerView: some View {
        VStack(spacing: .m) {

            MainButton(text: "I Agree", type: .primary, action: {
                viewModel.handleAgree()
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
    PolicyView(viewModel: .init(appState: AppStateManager()))
}

extension AttributedString {
    init(styledMarkdown markdownString: String) throws {
        var output = try AttributedString(
            markdown: markdownString,
            options: .init(
                allowsExtendedAttributes: true,
                interpretedSyntax: .full,
                failurePolicy: .returnPartiallyParsedIfPossible
            ),
            baseURL: nil
        )

        for (intentBlock, intentRange) in output.runs[AttributeScopes.FoundationAttributes.PresentationIntentAttribute.self].reversed() {
            guard let intentBlock = intentBlock else { continue }
            for intent in intentBlock.components {
                switch intent.kind {
                case .header(level: let level):
                    switch level {
                    case 1:
                        output[intentRange].font = .system(.title).bold()
                    case 2:
                        output[intentRange].font = .system(.title2).bold()
                    case 3:
                        output[intentRange].font = .system(.title3).bold()
                    default:
                        break
                    }
                default:
                    break
                }
            }
            
            if intentRange.lowerBound != output.startIndex {
                output.characters.insert(contentsOf: "\n", at: intentRange.lowerBound)
            }
            
            
        }

        self = output
    }
}
