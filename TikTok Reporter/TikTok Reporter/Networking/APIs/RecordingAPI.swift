//
//  RecordingAPI.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 07.12.2023.
//

import Foundation

enum RecordingAPI: APIRequest {
    case uploadRecording(contentType: String, body: Data)

    var method: APIMethod {
        switch self {
        case .uploadRecording:
            return .POST
        }
    }

    var path: String {
        switch self {
        case .uploadRecording:
            return "storage"
        }
    }

    var body: Data? {
        switch self {
        case let .uploadRecording(_, data):
            return data
        }
    }

    var headers: [String : String]? {
        switch self {
        case let .uploadRecording(contentType, _):
            return [
                "Content-Type": contentType,
                "X-API-Key": "c11442cb-790c-40f9-a357-a8205841e1f4"
            ]
        }
    }
}
