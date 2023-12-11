//
//  FormView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 07.11.2023.
//

import SwiftUI

struct FormView: View {
    
    // MARK: - Properties
    
    @StateObject
    var viewModel: ViewModel
    
    // MARK: - Body
    
    var body: some View {
        
        VStack {

            ScrollView {

                VStack(alignment: .leading, spacing: .xl) {
                    formItems
                }
                .padding(.xl)
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }

    // MARK: - Views

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
                    
                    MainTextField(text: $field.stringValue, isValid: $field.isValid, isEnabled: $field.isEnabled, placeholder: fieldInfo.placeholder, isMultiline: fieldInfo.multiline)
                case let .slider(fieldInfo):
                    
                    SliderView(value: $field.doubleValue, max: fieldInfo.max, step: fieldInfo.step, leftLabel: fieldInfo.leftLabel, rightLabel: fieldInfo.rightLabel)
                case let .dropDown(fieldInfo):
                    
                    DropDownView(selected: $field.stringValue, isValid: $field.isValid, options: fieldInfo.options, placeholder: fieldInfo.placeholder)
                        .onChange(of: field.stringValue) { selected in

                            guard let otherId = viewModel.otherId, selected == otherId else {
                                viewModel.removeOther()
                                return
                            }

                            viewModel.insertOther()
                        }
                }
            }
            .onChange(of: viewModel.formUIContainer.items[0].stringValue) { newValue in
                
                guard !newValue.isEmpty else {
                    viewModel.didUpdateMainField = false
                    return
                }

                viewModel.didUpdateMainField = true
            }
        }
    }
}

// MARK: - Preview
    
#Preview {
    FormView(viewModel: .init(formUIContainer: .constant(FormInputMapper.map(form: PreviewHelper.mockReportForm)), didUpdateMainField: .constant(false)))
}
