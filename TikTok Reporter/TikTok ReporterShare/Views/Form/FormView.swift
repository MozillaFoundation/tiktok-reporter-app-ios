//
//  FormView.swift
//  TikTok ReporterShare
//
//  Created by Sergiu Ghiran on 21.11.2023.
//

import SwiftUI

struct FormView: View {
    
    // MARK: - Properties
    
    @ObservedObject
    private(set) var viewModel: ViewModel
    
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
            ScrollView {
                VStack(alignment: .leading, spacing: .s) {
                    formItems
                }
                .padding(.xl)
            }

            VStack {
                MainButton(text: "Submit Report", type: .action) {
                    guard viewModel.formUIContainer.validate() else {
                        return
                    }

                    NotificationCenter.default.post(name: NSNotification.Name("close"), object: nil)
                }
            
                MainButton(text: "Cancel Report", type: .secondary) {
                    NotificationCenter.default.post(name: NSNotification.Name("close"), object: nil)
                }
            }
            .padding(.horizontal, .xl)
        }
    }

    private var formItems: some View {

        ForEach($viewModel.formUIContainer.items) { $field in
            
            VStack(alignment: .leading, spacing: .m) {

                // MARK: - Label

                if let label = field.formItem.label, !label.isEmpty {
                    Text(label)
                        .font(.body1)
                        .foregroundStyle(.text)
                }

                // MARK: - Description

                if let description = field.formItem.description, !description.isEmpty {
                    Text(description)
                        .font(.body2)
                        .foregroundStyle(.text)
                }

                // MARK: - Field

                switch field.formItem.field {
                    
                case let .textField(fieldInfo):
                    
                    ShareTextField(text: $field.stringValue, isValid: $field.isValid, isEnabled: $field.isEnabled, placeholder: fieldInfo.placeholder, isMultiline: fieldInfo.multiline)
                case let .slider(fieldInfo):
                    
                    ShareSlider(value: $field.doubleValue, max: fieldInfo.max, step: fieldInfo.step, leftLabel: fieldInfo.leftLabel, rightLabel: fieldInfo.rightLabel)
                case let .dropDown(fieldInfo):
                    
                    ShareDropDown(selected: $field.stringValue, isValid: $field.isValid, options: fieldInfo.options, placeholder: fieldInfo.placeholder)
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
