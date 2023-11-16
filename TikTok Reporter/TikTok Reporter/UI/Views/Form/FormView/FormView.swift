//
//  FormView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 07.11.2023.
//

import SwiftUI

struct FormView: View {
    
    // MARK: - Properties
    
    @ObservedObject
    var viewModel: ViewModel
    
    // MARK: - Body
    
    var body: some View {
        
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: .s) {
                    formItems
                }
                .padding(.xl)
            }

            if viewModel.hasSubmit {
                MainButton(text: "Submit Report", type: .action) {
                    viewModel.validate()
                }
                .padding(.horizontal, .l)
            }
        }
    }

    // MARK: - Views

    private var formItems: some View {

        ForEach($viewModel.formItems) { $field in
            
            VStack(alignment: .leading, spacing: .m) {

                // MARK: - Label

                if let label = field.formItem.label, !label.isEmpty {
                    Text(label)
                        .font(.heading3)
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
                    
                    MainTextField(text: $field.stringValue, isValid: $field.isValid, placeholder: fieldInfo.placeholder, isMultiline: fieldInfo.multiline)
                case let .slider(fieldInfo):
                    
                    SliderView(value: $field.doubleValue, max: fieldInfo.max, step: fieldInfo.step, leftLabel: fieldInfo.leftLabel, rightLabel: fieldInfo.rightLabel)
                case let .dropDown(fieldInfo):
                    
                    DropDownView(selected: $field.stringValue, isValid: $field.isValid, options: fieldInfo.options, placeholder: fieldInfo.placeholder)
                }
            }
        }
    }
}
    
    #Preview {
        FormView(viewModel: .init(form: PreviewHelper.mockOnboardingForm))
    }
