//
//  FormViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 08.11.2023.
//

import SwiftUI

extension FormView {

    // MARK: - ViewModel

    class ViewModel: ObservableObject {

        // MARK: - Properties

        var form: Form
        var hasSubmit: Bool

        @Published
        var formItems: [FormUIRepresentable]
        @Published
        var shouldShowOther: Bool = false

//        private lazy var otherField: FormUIRepresentable = {
//
//            let field = FormUIRepresentable(formItem: FormItem(id: "", label: <#T##String?#>, description: <#T##String?#>, isRequired: <#T##Bool#>, field: <#T##FormField#>)
//        }()

        // MARK: - Lifecycle

        init(form: Form, hasSubmit: Bool = false) {
            self.form = form
            self.hasSubmit = hasSubmit

            self.formItems = form.fields.map({ FormUIRepresentable(formItem: $0) })
        }

        // MARK: - Methods

        func validate() {
            for index in formItems.indices {
                formItems[index].validate()
            }
        }

//        private func insertOther() {
//            guard let dropDownIndex = formItems.firstIndex(where: {
//                if case let .dropDown(fieldItem) = $0.formItem.field {
//                    return fieldItem.hasOtherOption
//                }
//            
//                return false
//            }) else {
//                return
//            }
//
//            let other
//        }
    }
}
