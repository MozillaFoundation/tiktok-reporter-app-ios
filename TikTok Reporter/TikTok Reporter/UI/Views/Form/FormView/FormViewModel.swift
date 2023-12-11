//
//  FormViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 08.11.2023.
//

import SwiftUI

extension FormView {

    // MARK: - ViewModel

    final class ViewModel: ObservableObject {

        // MARK: - Properties

        private(set) var otherId: String? = nil
        private(set) var otherFieldId: String? = nil

        @Binding
        var formUIContainer: FormInputContainer
        @Binding
        var didUpdateMainField: Bool
    
        private lazy var otherField: FormInputField = {

            return FormInputField(formItem: FormItem(id: "other", label: nil, description: nil, isRequired: true, field: .textField(TextFieldFormField(placeholder: Strings.otherFieldTitle, maxLines: 1, multiline: false))))
        }()

        // MARK: - Lifecycle

        init(formUIContainer: Binding<FormInputContainer>, didUpdateMainField: Binding<Bool>) {

            self._formUIContainer = formUIContainer
            self._didUpdateMainField = didUpdateMainField

            self.formUIContainer.items.forEach { formItem in

                if case let .dropDown(fieldItem) = formItem.formItem.field, fieldItem.hasOtherOption {
                    self.otherFieldId = formItem.id
                    self.otherId = fieldItem.options.first(where: { $0.title.lowercased() == Strings.otherTitle })?.id
                }
            }
        }

        // MARK: - Methods

        func insertOther() {

            guard
                let otherFieldId = otherFieldId,
                let dropDownIndex = formUIContainer.items.firstIndex(where: { $0.formItem.id == otherFieldId })
            else {
                return
            }

            formUIContainer.items.insert(otherField, at: dropDownIndex + 1)
        }

        func removeOther() {
            guard let otherFieldIndex = formUIContainer.items.firstIndex(where: { $0.id == otherField.id }) else {
                return
            }

            formUIContainer.items.remove(at: otherFieldIndex)
        }
    }
}

// MARK: - Strings

private enum Strings {
    static let otherFieldTitle = "Suggest a category"
    static let otherTitle = "other"
}
