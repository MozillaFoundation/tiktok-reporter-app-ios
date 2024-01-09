//
//  RecordingStorage.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 08.12.2023.
//

import Foundation

struct RecordingStorage: Codable {
    let bucketName: String
    let id: String
    let name: String
    let storageUrl: String
}
