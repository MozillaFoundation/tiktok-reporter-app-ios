//
//  SettingsView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 14.11.2023.
//

import SwiftUI

struct SettingsView: View {

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
        
        ScrollView {
            
            VStack(alignment: .leading) {

                settings

                NavigationLink(destination: AboutView()) {
                    aboutRow
                }

                if let study = viewModel.study {

                    NavigationLink(destination: StudySelectionView(viewModel: .init(appState: viewModel.appState, viewState: .prefilled(study)))) {
                        studiesRow
                    }
                }

                if let form = viewModel.onboardingForm {

                    NavigationLink(
                        destination: OnboardingFormView(viewModel: .init(appState: viewModel.appState, form: form, location: .settings))
                    ) {
                        emailRow
                    }
                }

                if let termsAndConditions = viewModel.termsAndConditions {

                    NavigationLink(destination: PolicyView(viewModel: .init(appState: viewModel.appState, policyType: .specific(termsAndConditions), hasActions: false))) {
                        termsRow
                    }
                }

                if let termsAndConditions = viewModel.privacyPolicy {

                    NavigationLink(destination: PolicyView(viewModel: .init(appState: viewModel.appState, policyType: .specific(termsAndConditions), hasActions: false))) {
                        privacyRow
                    }
                }

                if viewModel.emailAddress != nil {

                    NavigationLink(destination: DataHandlingView(viewModel: .init(appState: viewModel.appState))) {
                        dataHandlingRow
                    }
                }
            }
        }
    }

    private var settings: some View {
        Text("Settings")
            .font(.heading3)
            .foregroundStyle(.text)
            .padding(.l)
    }

    private var aboutRow: some View {
        SettingsRow(title: "ABOUT TIKTOK REPORTER")
    }

    private var studiesRow: some View {
        SettingsRow(title: "STUDIES")
    }
    
    private var emailRow: some View {
        SettingsRow(title: "EMAIL ADDRESS")
    }

    private var termsRow: some View {
        SettingsRow(title: "TERMS & CONDITIONS")
    }

    private var privacyRow: some View {
        SettingsRow(title: "PRIVACY POLICY")
    }

    private var dataHandlingRow: some View {
        SettingsRow(title: "DATA HANDLING")
    }
}

// MARK: - Preview

#Preview {
    SettingsView(viewModel: .init(appState: AppStateManager()))
}
