//
//  FormView.swift
//  TikTok ReporterShare
//
//  Created by Sergiu Ghiran on 21.11.2023.
//

import SwiftUI

struct FormView: View {
    
    // MARK: - Properties
    
    @StateObject
    var viewModel: ViewModel
    
    // MARK: - Body
    
    var body: some View {

        NavigationView {

            PresentationStateView(viewModel: viewModel) {

                self.content
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Image(.header)
                        }
                    }
            }
        }
    }

    // MARK: - Views

    private var content: some View {

        VStack {

            self.form
            self.buttonStack
        }
    }

    private var form: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: .s) {

                formItems
            }
            .padding(.xl)
        }
    }

    private var buttonStack: some View {

        VStack {

            MainButton(text: Strings.submitTitle, type: .action) {

                viewModel.submitReport()
            }
        
            MainButton(text: Strings.cancelTitle, type: .secondary) {

                viewModel.cancelReport()
            }
        }
        .padding(.horizontal, .xl)
    }

    private var formItems: some View {

        ForEach($viewModel.formInputContainer.items) { $field in
            
            VStack(alignment: .leading, spacing: .m) {

                // Label
                if let label = field.formItem.label, !label.isEmpty {
                    Text(label)
                        .font(.body1)
                        .foregroundStyle(.text)
                }

                // Description
                if let description = field.formItem.description, !description.isEmpty {
                    Text(description)
                        .font(.body2)
                        .foregroundStyle(.text)
                }

                // Field
                switch field.formItem.field {
                    
                case let .textField(fieldInfo):
                    
                    MainTextField(text: $field.stringValue, isValid: $field.isValid, isEnabled: $field.isEnabled, placeholder: fieldInfo.placeholder, isMultiline: fieldInfo.multiline)
                case let .slider(fieldInfo):
                    
                    SliderView(value: $field.doubleValue, max: fieldInfo.max, step: fieldInfo.step, leftLabel: fieldInfo.leftLabel, rightLabel: fieldInfo.rightLabel)
                case let .dropDown(fieldInfo):
                    
                    DropDownView(selected: $field.stringValue, isValid: $field.isValid, options: fieldInfo.options, placeholder: fieldInfo.placeholder, hasOtherOption: fieldInfo.hasOtherOption)
                        .onChange(of: field.stringValue) { selected in
                            guard let otherId = viewModel.otherId, selected == otherId else {
                                viewModel.removeOther()
                                return
                            }

                            viewModel.insertOther()
                        }
                }
            }
        }
    }
}

// MARK: - Strings

private enum Strings {

    // Buttons
    static let submitTitle = "Submit Report"
    static let cancelTitle = "Cancel Report"

    // Notification
    static let closeNotificationName = "close"
}
