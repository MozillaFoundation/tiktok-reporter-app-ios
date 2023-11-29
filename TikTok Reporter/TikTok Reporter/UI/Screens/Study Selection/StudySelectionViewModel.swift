//
//  StudySelectionViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 02.11.2023.
//

import SwiftUI

extension StudySelectionView {

    // MARK: - Routing

    struct Routing {
        var alert: Bool = false
    }

    // MARK: - ViewModel

    class ViewModel: PresentationStateObject {

        // MARK: - State

        enum State: Equatable {
            case empty, prefilled(Study)
        }

        // MARK: - Injected

        @Injected(\.studiesService)
        private var service: StudiesServicing

        // MARK: - Properties

        private(set) var appState: AppStateManager

        @Published
        var routingState: Routing = .init()
        @Published
        var state: PresentationState = .idle
        @Published
        var studies: [Study] = []
        @Published
        var selected: Study?

        var prefilledStudy: Study?
        var tempStudy: Study? = nil
        var viewState: State

        // MARK: - Lifecycle

        init(appState: AppStateManager, viewState: State = .empty) {
            self.appState = appState
            self.viewState = viewState

            if case let .prefilled(study) = viewState {
                prefilledStudy = study
                selected = study
            }
        }

        // MARK: - Methods

        func load() {
            state = .loading

            Task {
                do {
                    let apiStudies: [Study]? = try await service.getStudies()

                    await MainActor.run {
                        guard let studies = apiStudies, studies.contains(where: { $0.form != nil }) else {
                            state = .idle
                            return
                        }

                        self.studies = studies.filter({ $0.form != nil })
                        // TODO: - Remove before release.
                        self.studies.append(TestStudyProvider.study)

                        if selected == nil {
                            selected = studies.first(where: { $0.isActive })
                        }

//                        state = .success
                        state = .failed
                    }
                } catch let error {
                    // TODO: - Handle error
                    state = .failed
                    print(error.localizedDescription)
                }
            }
        }
    
        func saveStudy() {
            // TODO: - Show error to user
            guard let study = selected else {
                return
            }

            tempStudy = nil

            do {
                try appState.save(study, for: .study)
                try appState.save(false, for: .hasCompletedOnboarding)

                appState.setOnboarding(with: study)
            } catch let error {
                // TODO: - Add error handling
                print(error.localizedDescription)
            }
        }

        func resetSelected() {
            selected = tempStudy
            tempStudy = nil
        }
    }
}

// TODO: - ONLY FOR TESTING!! Remove before release

enum TestStudyProvider {
    static let study: Study =
        Study(
            id: "1",
            name: "Test Onboarding Study",
            description: "This is a local study.",
            isActive: true,
            supportsRecording: true,
            countryCodes: [],
            policies: [
                Policy(
                    id: "11",
                    type: .termsOfService,
                    title: "Thank you for joining TikTok Reporter, a Mozilla app to help us study TikTok’s FYP algorithm",
                    subtitle: "Before we start, please read and agree to the terms and conditions.",
                    text: "What’s the Difference Between Terms and Conditions and a Privacy Policy? A Terms and Conditions agreement is very different from a Privacy Policy. A Privacy Policy is a type of notice that sets out information such as: What types of personal information you collect How you collect it How you share personal information What rights your users have over their personal information. By law, almost every business must post a Privacy Policy on its website and/or app. Some of the key privacy laws that require this include: California Online Privacy Protection Act (CalOPPA) EU General Data Protection Regulation (GDPR) Canada’s Protection of Personal Information and Electronic Documents Act (PIPEDA) For more information, see our article Privacy Policies vs. Terms & Conditions.",
                    studies: []
                )
            ],
            onboarding: Onboarding(
                id: "12",
                name: "Test Onboarding",
                steps: [
                    OnboardingStep(
                        id: "121",
                        title: "Here is how you can use the app to share videos with us you are seeing",
                        subtitle: "Sharing a link",
                        description: "Tap TikTok’s share button.",
                        imageUrl: "https://images.unsplash.com/photo-1553061592-03b4b2df2f66?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MXwxMDE5NDU4fHxlbnwwfHx8fHw%3D",
                        details: nil,
                        order: 0,
                        onboardings: []
                    ),
                    OnboardingStep(
                        id: "122",
                        title: "Here is how you can use the app to share videos with us you are seeing",
                        subtitle: "Sharing a link",
                        description: "Then, choose the app TikTokReporter.*",
                        imageUrl: "https://i.pinimg.com/originals/73/46/59/7346590e31ba88e3a966abfe08d4a303.jpg",
                        details: "*You can also just copy and paste the link in our app.",
                        order: 1,
                        onboardings: []
                    ),
                    OnboardingStep(
                        id: "123",
                        title: "Here is how you can use the app to share videos with us you are seeing",
                        subtitle: "Sharing a link",
                        description: "Fill out some information, then hit Submit.",
                        imageUrl: "https://e0.pxfuel.com/wallpapers/232/68/desktop-wallpaper-1200%C3%971920-vertical-cool-portrait-thumbnail.jpg",
                        details: nil,
                        order: 2,
                        onboardings: []
                    ),
                    OnboardingStep(
                        id: "124",
                        title: "Here is how you can use the app to share videos with us you are seeing",
                        subtitle: "Sharing a link",
                        description: "Fill out some information, then submit the form with the video file attached.",
                        imageUrl: "https://i.pinimg.com/originals/42/73/b7/4273b7c22af24b9d4bade05c28cdc2ac.jpg",
                        details: nil,
                        order: 3,
                        onboardings: []
                    )
                ],
                form: Form(
                    id: "13",
                    name: "Test Form",
                    fields: [
                        FormItem(id: "131", label: "Sign up for updates", description: "If you would like to receive updates on this study and participate in future studies, please provide your email address.", isRequired: false, field: .textField(TextFieldFormField(placeholder: "Your e-mail (optional)", maxLines: 1, multiline: false)))
                    ]
                )
            ),
            form: Form(
                id: "14",
                name: "Record Test Form",
                fields: [
                    FormItem(id: "141", label: nil, description: nil, isRequired: true, field: .textField(TextFieldFormField(placeholder: "TikTok link", maxLines: 1, multiline: false))),
                    FormItem(id: "142", label: nil, description: "Tell us why you choose to flag this video by selecting a category in the dropdown menu. If you don’t see a category that matches in the list, select “other”.", isRequired: true, field: .dropDown(DropDownFormField(placeholder: "Category", options: [DropDownOption(id: "1421", title: "Age-restricted content"), DropDownOption(id: "1422", title: "Animal abuse"), DropDownOption(id: "1423", title: "Child safety"), DropDownOption(id: "1424", title: "Fake engagement"), DropDownOption(id: "1425", title: "Firearms"), DropDownOption(id: "1426", title: "Harassment & cyber bullying"), DropDownOption(id: "1427", title: "Other")], selected: "", hasOtherOption: true))),
                    FormItem(id: "143", label: "Severity", description: nil, isRequired: true, field: .slider(SliderFormField(max: 5, step: 1, leftLabel: "LOW", rightLabel: "HIGH"))),
                    FormItem(id: "144", label: nil, description: nil, isRequired: false, field: .textField(TextFieldFormField(placeholder: "Comments (optional)", maxLines: 10, multiline: true)))
                ]
            )
        )
}
