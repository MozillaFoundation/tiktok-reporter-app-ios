//
//  FormUIRepresentable.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 09.11.2023.
//

import Foundation

struct FormUIRepresentable: Hashable, Identifiable {
    let id: String
    let formItem: FormItem
    
    var stringValue: String = ""
    var boolValue: Bool = false
    var doubleValue: Double = 0.0

    var isValid: Bool = true

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
