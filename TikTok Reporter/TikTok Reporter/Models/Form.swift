//
//  Form.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 02.11.2023.
//

import Foundation
import SwiftUI

struct Form: Codable, Hashable {
    let id: String
    let name: String
    let fields: [FormItem]
}

struct FormItem: Codable, Hashable, Identifiable {
    let id: String
    let label: String?
    let description: String?
    let isRequired: Bool
    let field: FormField

    enum CodingKeys: String, CodingKey {
        case id, label, description, isRequired
    }
    
    init(id: String, label: String?, description: String?, isRequired: Bool, field: FormField) {
        self.id = id
        self.label = label
        self.description = description
        self.isRequired = isRequired
        self.field = field
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        label = try container.decodeIfPresent(String.self, forKey: .label)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        isRequired = try container.decode(Bool.self, forKey: .isRequired)
        field = try FormField(from: decoder)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(label, forKey: .label)
        try container.encode(description, forKey: .description)
        try container.encode(isRequired, forKey: .isRequired)

        try field.encode(to: encoder)
    }
}

enum FormFieldType: String, Codable {
    case textField = "TextField"
    case dropDown = "DropDown"
    case slider = "Slider"
}

enum FormField: Codable, Hashable {
    case dropDown(DropDownFormField)
    case textField(TextFieldFormField)
    case slider(SliderFormField)

    enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(FormFieldType.self, forKey: .type)
        switch type {
        case .dropDown:
            let field = try DropDownFormField(from: decoder)
            self = .dropDown(field)
        case .textField:
            let field = try TextFieldFormField(from: decoder)
            self = .textField(field)
        case .slider:
            let field = try SliderFormField(from: decoder)
            self = .slider(field)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .dropDown(model):
            try container.encode(FormFieldType.dropDown, forKey: .type)
            try model.encode(to: encoder)
        case let .textField(model):
            try container.encode(FormFieldType.textField, forKey: .type)
            try model.encode(to: encoder)
        case let .slider(model):
            try container.encode(FormFieldType.slider, forKey: .type)
            try model.encode(to: encoder)
        }
    }
}

// MARK: - TextField

struct TextFieldFormField: Codable, Hashable {
    let placeholder: String
    let maxLines: Int
    let multiline: Bool
}

// MARK: - DropDown

struct DropDownOption: Codable, Hashable, Identifiable {
    let id: String
    let title: String
}

struct DropDownFormField: Codable, Hashable {
    let placeholder: String
    let options: [DropDownOption]
    let selected: String
    let hasOtherOption: Bool
}

// MARK: - Slider

struct SliderFormField: Codable, Hashable {
    let max: Double
    let step: Double
    let leftLabel: String
    let rightLabel: String
}
