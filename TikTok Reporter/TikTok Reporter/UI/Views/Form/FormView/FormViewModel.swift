//
//  FormViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 08.11.2023.
//

import SwiftUI

extension FormView {
    
    struct FormAction: Identifiable {
        var id: String {
            title
        }
        var title: String
        var action: () -> ()
        var buttonType: ButtonType
        var shouldValidate: Bool
        var isAlwaysVisible: Bool
    }

    // MARK: - ViewModel

    final class ViewModel: ObservableObject {

        // MARK: - Properties

        private(set) var otherId: String? = nil
        private(set) var otherFieldId: String? = nil

        @Binding
        var formUIContainer: FormUIContainer
        @Binding
        var didUpdateMainField: Bool
    
        private lazy var otherField: FormUIRepresentable = {

            return FormUIRepresentable(formItem: FormItem(id: "", label: nil, description: nil, isRequired: true, field: .textField(TextFieldFormField(placeholder: "Suggest a category", maxLines: 1, multiline: false))))
        }()

        // MARK: - Lifecycle

        init(formUIContainer: Binding<FormUIContainer>, didUpdateMainField: Binding<Bool>) {
            self._formUIContainer = formUIContainer
            self._didUpdateMainField = didUpdateMainField

            self.formUIContainer.items.forEach { formItem in
                if case let .dropDown(fieldItem) = formItem.formItem.field, fieldItem.hasOtherOption {
                    self.otherFieldId = formItem.id
                    self.otherId = fieldItem.options.first(where: { $0.title.lowercased() == "other" })?.id
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
            guard let otherFieldIndex = formUIContainer.items.firstIndex(of: otherField) else {
                return
            }

            formUIContainer.items.remove(at: otherFieldIndex)
        }
    }
}
