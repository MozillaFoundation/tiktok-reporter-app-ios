//
//  EmailSubmissionView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 07.11.2023.
//

import SwiftUI

struct EmailSubmissionView: View {
    
    // MARK: - Properties

    @State
    var text: String = ""
    @FocusState
    var inFocus: Int?

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
        VStack {
            emailView
            buttons
        }
    }

    private var emailView: some View {

        ScrollViewReader { scrollView in

            ScrollView {

                VStack(alignment: .leading, spacing: .xl) {

                    Text("Your e-mail")
                        .font(.heading3)
                        .foregroundStyle(.text)
                    Text("If you would like to receive updates on this study and others, please provide your email.")
                        .font(.body2)
                    MainTextField(text: $text, placeholder: "E-mail", type: .email)
                        .id(0)
                        .focused($inFocus, equals: 0)
                        .frame(height: 56.0)
                }
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
                
            }

            MainButton(text: "Skip", type: .secondary) {
                
            }
        }
        .padding(.l)
    }
}

#Preview {
    EmailSubmissionView()
}
