//
//  FormInputField.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 09.11.2023.
//

import Foundation

struct FormInputField: Hashable, Identifiable {

    // MARK: - Properties

    let id: String
    let formItem: FormItem
    
    var stringValue: String = ""
    var boolValue: Bool = false
    var doubleValue: Double = 0.0

    var isValid: Bool = true
    var isEnabled: Bool = true

    // MARK: - Lifecycle

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

    // MARK: - Methods

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

    mutating func reset() {
        stringValue = ""
        boolValue = false
        doubleValue = 0.0
    }
}

extension FormInputField: Encodable {

    enum CodingKeys: String, CodingKey {
        case formItem
        case inputValue
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(formItem, forKey: .formItem)

        switch formItem.field {
        case .textField, .dropDown:
            try container.encode(stringValue, forKey: .inputValue)
        case .slider:
            try container.encode(doubleValue, forKey: .inputValue)
        }
    }
}

struct FormInputContainer: Encodable, Hashable {

    // MARK: - Properties

    let id: String
    let name: String
    var items: [FormInputField]
    

    // MARK: - Lifecycle

    init(id: String, name: String, items: [FormInputField]) {
        self.id = id
        self.name = name
        self.items = items
    }

    // MARK: - Methods

    mutating func validate() -> Bool {
        for index in items.indices {
            items[index].validate()
        }

        return !items.contains(where: { $0.isValid == false })
    }
    
    mutating func getFirstUnvalidatedItem() -> Int? {
        for index in 0..<items.count {
            items[index].validate()
        }
        
        return items.firstIndex { $0.isValid == false }
    }

    mutating func reset() {
        for index in items.indices {
            items[index].reset()
        }
    }

    mutating func updateOtherField(_ didSelectOther: Bool, on dropDown: FormInputField) {

        guard 
            let itemIndex = items.firstIndex(of: dropDown),
            itemIndex < items.count
        else {
            return
        }
        
        if didSelectOther {
            items.insert(otherField(for: dropDown.id), at: itemIndex + 1)
        } else {
            guard let firstIndexToRemove = items.firstIndex(where: { $0.id.contains("-other") }) else { return }
            items.remove(at: firstIndexToRemove)
        }
    }

    private func otherField(for dropDownId: String) -> FormInputField {

        return FormInputField(formItem: FormItem(id: dropDownId + "-other", label: nil, description: nil, isRequired: true, field: .textField(TextFieldFormField(placeholder: Strings.otherFieldTitle, maxLines: 1, multiline: false, isTikTokLink: false))))
    }
}

struct FormInputMapper {
    static func map(form: Form) -> FormInputContainer {
        return FormInputContainer(id: form.id, name: form.name, items: form.fields.map({ FormInputField(formItem: $0) }))
    }
}

private enum Strings {
    static let otherFieldTitle = "Suggest a category"
}
