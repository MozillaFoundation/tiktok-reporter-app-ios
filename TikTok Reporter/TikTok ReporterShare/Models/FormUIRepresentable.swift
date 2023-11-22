//
//  FormUIRepresentable.swift
//  TikTok ReporterShare
//
//  Created by Sergiu Ghiran on 21.11.2023.
//

import Foundation

struct FormUIRepresentable: Hashable, Identifiable {
    let id: String
    let formItem: FormItem
    
    var stringValue: String = ""
    var boolValue: Bool = false
    var doubleValue: Double = 0.0

    var isValid: Bool = true
    var isEnabled: Bool = true

    init(formItem: FormItem) {
        self.formItem = formItem
        self.id = formItem.id

        switch formItem.field {
        case let .dropDown(field):
            stringValue = field.selected
        default:
            return
        }
    }

    mutating func validate() {
        guard formItem.isRequired else {
            return
        }

        switch formItem.field {
        case .textField, .dropDown:
            isValid = !stringValue.isEmpty
        default:
            return
        }
    }
}

struct FormUIContainer {

    // MARK: - Properties

    var items: [FormUIRepresentable]

    // MARK: - Methods

    mutating func validate() -> Bool {
        for index in items.indices {
            items[index].validate()
        }

        return !items.contains(where: { $0.isValid == false })
    }
}

struct FormUIMapper {
    static func map(form: Form) -> FormUIContainer {
        return FormUIContainer(items: form.fields.map({ FormUIRepresentable(formItem: $0) }))
    }
}

