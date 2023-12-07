//
//  FormJSONMapper.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 06.12.2023.
//

import Foundation

final class FormJSONMapper {

    // MARK: - Error

    enum JSONError: Error {
        case mappingError
    }

    // MARK: - Methods

    static func map(_ formContainer: FormInputContainer) throws -> String {
            
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let jsonData = try encoder.encode(formContainer)
        
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw JSONError.mappingError
        }

        return NSString(string: jsonString) as String
    }
}
