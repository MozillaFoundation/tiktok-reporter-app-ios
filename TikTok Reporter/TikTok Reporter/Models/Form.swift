//
//  Form.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 02.11.2023.
//

import Foundation

struct Form: Codable {
    let id: String
    let name: String
    let fields: [FormField]
}

enum FormFieldType: String, Codable {
    case textField = "TextFields"
}

struct FormField: Codable {
    let id: String
    let type: FormFieldType
    let label: String
    let description: String
    let isRequired: Bool
}

extension Form: Hashable {}
extension FormField: Hashable {}
