//
//  FormJSONMapper.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 06.12.2023.
//

import Foundation

final class JSONMapper {

    // MARK: - Error

    enum JSONError: Error {
        case mappingError
    }

    // MARK: - Methods

    static func map(_ value: Encodable) throws -> String {
            
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let jsonData = try encoder.encode(value)
        
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw JSONError.mappingError
        }

        return NSString(string: jsonString) as String
    }
}
