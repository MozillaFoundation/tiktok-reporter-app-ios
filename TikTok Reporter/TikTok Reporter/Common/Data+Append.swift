//
//  Data+Append.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 08.12.2023.
//

import Foundation

extension Data {

    mutating func append(_ string: String, encoding: String.Encoding = .utf8) {

        guard let data = string.data(using: encoding) else {
            return
        }

        append(data)
    }
}
