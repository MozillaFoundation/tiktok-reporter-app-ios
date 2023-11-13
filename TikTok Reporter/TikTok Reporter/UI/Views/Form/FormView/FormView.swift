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
        
        VStack(alignment: .leading, spacing: .s) {
            
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
                        
                        MainTextField(text: $field.stringValue, placeholder: fieldInfo.placeholder)
                    case let .slider(fieldInfo):
                        
                        SliderView(value: $field.doubleValue, max: fieldInfo.max, step: fieldInfo.step, leftLabel: fieldInfo.leftLabel, rightLabel: fieldInfo.rightLabel)
                    case let .dropDown(fieldInfo):
                        DropDownView(selected: $field.stringValue, options: fieldInfo.options, placeholder: fieldInfo.placeholder)
                    }
                }
            }
        }
    }
}
    
    #Preview {
        FormView(viewModel: .init(form: PreviewHelper.mockOnboardingForm))
    }
