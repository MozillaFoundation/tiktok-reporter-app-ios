//
//  MultipartRequest.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 08.12.2023.
//

import Foundation

struct MultipartRequest {

    // MARK: - Properties

    private let boundary: String
    private let separator = "\r\n"
    private var data: Data

    var httpHeader: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    var httpBody: Data {
        var bodyData = data
        bodyData.append("--\(boundary)--")
        return bodyData
    }

    // MARK: - Lifecycle

    init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
        self.data = .init()
    }

    // MARK: - Methods

    mutating func add(key: String, fileName: String, fileMimeType: String, fileData: Data) {

        appendBoundary()
        data.append(disposition(key) + "; filename=\"\(fileName)\"" + separator)
        data.append("Content-Type: \(fileMimeType)" + separator + separator)
        data.append(fileData)
        appendSeparator()
    }

    // MARK: - Private Methods

    private mutating func appendBoundary() {
        data.append("--\(boundary)\(separator)")
    }

    private mutating func appendSeparator() {
        data.append(separator)
    }

    private func disposition(_ key: String) -> String {
        return "Content-Disposition: form-data; name=\"\(key)\""
    }
}
