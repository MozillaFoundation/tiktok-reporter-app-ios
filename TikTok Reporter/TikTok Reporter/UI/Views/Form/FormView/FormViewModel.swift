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

        @Published
        var formItems: [FormUIRepresentable]

        // MARK: - Lifecycle

        init(form: Form) {
            self.form = form
            self.formItems = form.fields.map({ FormUIRepresentable(formItem: $0) })
        }
    }
}
