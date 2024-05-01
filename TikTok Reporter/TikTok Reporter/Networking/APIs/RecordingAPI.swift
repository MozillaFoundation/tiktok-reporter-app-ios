//
//  RecordingAPI.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 07.12.2023.
//

import Foundation

enum RecordingAPI: APIRequest {
    case uploadRecording(contentType: String, body: Data)
    case getSignedUrlPath
    case uploadRecordingV4(v4SignedURL: String, body: Data)

    var method: APIMethod {
        switch self {
        case .uploadRecording:
            return .POST
        case .getSignedUrlPath:
            return .GET
        case .uploadRecordingV4(_, _):
            return .PUT
        }
    }

    var path: String {
        switch self {
        case .uploadRecording:
            return "storage"
        case .getSignedUrlPath:
            return "signedUrl"
        case .uploadRecordingV4(let v4SignedURL, _):
            return v4SignedURL
        }
    }

    var body: Data? {
        switch self {
        case let .uploadRecording(_, data):
            return data
        case .getSignedUrlPath:
            return nil
        case let .uploadRecordingV4(_, data):
            return data
        }
    }

    var headers: [String : String]? {
        switch self {
        case let .uploadRecording(contentType, _):
            return [
                "Content-Type": contentType,
                "X-API-Key": ProcessInfo.processInfo.environment["FYP_REPORTER_UPLOAD_API_KEY"] ?? ""
            ]
            
        case .getSignedUrlPath:
            return [
                "content-type": "application/json",
                "X-API-Key": ProcessInfo.processInfo.environment["FYP_REPORTER_UPLOAD_API_KEY"] ?? ""
            ]
            
        case .uploadRecordingV4(_, _):
            return [
                "content-type": "video/mov"
            ]
        }
    }
}
