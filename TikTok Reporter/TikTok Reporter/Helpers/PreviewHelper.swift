//
//  PreviewHelper.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 09.11.2023.
//

import Foundation

enum PreviewHelper {
    static let mockStudy = Study(
        id: "1",
        name: "Test Study",
        description: "This is a test study. Used for preview purposes.",
        isActive: true,
        supportsRecording: true,
        countryCodes: [],
        policies: [],
        onboarding: Onboarding(
            id: "11",
            name: "Test Onboarding",
            steps: [
                OnboardingStep(id: "111", title: "First Step", subtitle: "This is the first step", description: "Description for the first step.", imageUrl: "", details: "* Test details", order: 1, onboardings: []),
                OnboardingStep(id: "112", title: "Second Step", subtitle: "This is the second step", description: "Description for the second step.", imageUrl: "", details: "* Test details", order: 2, onboardings: [])
            ],
            form: Form(
                id: "21",
                name: "Onboarding test form",
                fields: [
                    FormItem(id: "211", label: "TextField form item", description: "This is a test item.", isRequired: true, field: .textField(TextFieldFormField(placeholder: "Placeholder", maxLines: 1, multiline: false))),
                    FormItem(id: "212", label: "Slider form item", description: "This is a test item.", isRequired: true, field: .slider(SliderFormField(max: 100, step: 10, leftLabel: "MIN", rightLabel: "MAX"))),
                    FormItem(id: "213", label: "DropDown form item", description: "This is a test item.", isRequired: true, field: .dropDown(DropDownFormField(placeholder: "Placeholder", options: [DropDownOption(id: "2131", title: "Option 1"), DropDownOption(id: "2132", title: "Option 2")], selected: "1", hasOtherOption: true)))
                ])),
        form: Form(
            id: "31",
            name: "Study form",
            fields: [
                FormItem(id: "311", label: nil, description: nil, isRequired: true, field: .textField(TextFieldFormField(placeholder: "TikTok link", maxLines: 1, multiline: false))),
                FormItem(id: "312", label: nil, description: "Choose a category in which the video you want to report can be included. If you don’t find the category in the list, choose “other”.", isRequired: true, field: .dropDown(DropDownFormField(placeholder: "Category", options: [DropDownOption(id: "3121", title: "Option 1"), DropDownOption(id: "3122", title: "Option 2")], selected: "3121", hasOtherOption: true))),
                FormItem(id: "313", label: "Severity", description: nil, isRequired: true, field: .slider(SliderFormField(max: 5, step: 1, leftLabel: "LOW", rightLabel: "HIGH")))
            ])
    )
    
    static let mockOnboarding = Onboarding(
        id: "11",
        name: "Test Onboarding",
        steps: [
            OnboardingStep(id: "111", title: "First Step", subtitle: "This is the first step", description: "Description for the first step.", imageUrl: "", details: "* Test details", order: 1, onboardings: []),
            OnboardingStep(id: "112", title: "Second Step", subtitle: "This is the second step", description: "Description for the second step.", imageUrl: "", details: "* Test details", order: 2, onboardings: [])
        ],
        form: Form(
            id: "21",
            name: "Onboarding test form",
            fields: [
                FormItem(id: "211", label: "TextField form item", description: "This is a test item.", isRequired: true, field: .textField(TextFieldFormField(placeholder: "Placeholder", maxLines: 1, multiline: false))),
                FormItem(id: "212", label: "Slider form item", description: "This is a test item.", isRequired: true, field: .slider(SliderFormField(max: 100, step: 10, leftLabel: "MIN", rightLabel: "MAX"))),
                FormItem(id: "213", label: "DropDown form item", description: "This is a test item.", isRequired: true, field: .dropDown(DropDownFormField(placeholder: "Placeholder", options: [DropDownOption(id: "2131", title: "Option 1"), DropDownOption(id: "2132", title: "Option 2")], selected: "1", hasOtherOption: true)))
            ])
    )
    
    static let mockOnboardingForm = Form(
        id: "31",
        name: "Study form",
        fields: [
            FormItem(id: "311", label: nil, description: nil, isRequired: true, field: .textField(TextFieldFormField(placeholder: "TikTok link", maxLines: 1, multiline: false))),
            FormItem(id: "312", label: nil, description: "Choose a category in which the video you want to report can be included. If you don’t find the category in the list, choose “other”.", isRequired: true, field: .dropDown(DropDownFormField(placeholder: "Category", options: [DropDownOption(id: "3121", title: "Option 1"), DropDownOption(id: "3122", title: "Option 2")], selected: "3121", hasOtherOption: true))),
            FormItem(id: "313", label: "Severity", description: nil, isRequired: true, field: .slider(SliderFormField(max: 5, step: 1, leftLabel: "LOW", rightLabel: "HIGH")))
        ]
    )
}
