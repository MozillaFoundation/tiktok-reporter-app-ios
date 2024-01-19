//
//  FormView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 07.11.2023.
//

import SwiftUI

struct FormView: View {
    
    // MARK: - Properties
    
    @Binding
    var formInputContainer: FormInputContainer
    @Binding
    var didUpdateMainField: Bool
    
    @Binding
    var shouldScrollToNonValidatedContext: Bool
    
    // MARK: - Body
    
    var body: some View {
        
        VStack {

            ScrollViewReader { scrollProxy in
                
                ScrollView {

                    VStack(alignment: .leading, spacing: .xl) {
                        
                        self.formItems
                    }
                    .padding(.xl)
                }
                .onChange(of: shouldScrollToNonValidatedContext) { value in
                    guard value,
                          let firstIndexForNonValidated = formInputContainer.getFirstUnvalidatedItem() else { return }
                    
                    withAnimation {
                        scrollProxy.scrollTo(firstIndexForNonValidated)
                    }
                }
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }

    // MARK: - Views

    private var formItems: some View {
        ForEach(Array($formInputContainer.items.enumerated()), id: \.offset) { index, $field in
            
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
                        .id(index)
                    
                case let .slider(fieldInfo):
                    
                    SliderView(value: $field.doubleValue, max: fieldInfo.max, step: fieldInfo.step, leftLabel: fieldInfo.leftLabel, rightLabel: fieldInfo.rightLabel)
                        .id(index)
                case let .dropDown(fieldInfo):
                    
                    DropDownView(selected: $field.stringValue, isValid: $field.isValid, options: fieldInfo.options, placeholder: fieldInfo.placeholder)
                        .id(index)
                        .onChange(of: field.stringValue) { selected in

                            guard 
                                fieldInfo.hasOtherOption,
                                let otherOption = fieldInfo.options.last?.id
                            else {
                                return
                            }

                            formInputContainer.updateOtherField(selected == otherOption, on: field)
                        }
                }
            }
            .onChange(of: formInputContainer.items[0].stringValue) { newValue in
                
                guard !newValue.isEmpty else {
                    didUpdateMainField = false
                    return
                }

                didUpdateMainField = true
            }
        }
    }
}

// MARK: - Preview
    
#Preview {
    FormView(formInputContainer: .constant(FormInputMapper.map(form: PreviewHelper.mockReportForm)), 
             didUpdateMainField: .constant(false),
             shouldScrollToNonValidatedContext: .constant(false))
}

// MARK: - Strings

private enum Strings {
    static let otherFieldTitle = "Suggest a category"
    static let otherTitle = "other"
}
