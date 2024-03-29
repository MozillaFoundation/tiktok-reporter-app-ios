//
//  ScreenRecordingService.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 28.11.2023.
//

import Foundation
import AVFoundation

enum FileManagerError: Error {
    case fileNotFound
}

protocol ScreenRecordingServicing {
    var localURL: URL? { get }

    func loadRecording() throws -> AVAsset
    func removeRecording() throws
    func updateLocalRecording(with path: String) throws -> AVAsset

    func uploadRecording() async throws -> RecordingStorage?
}

final class ScreenRecordingService: ScreenRecordingServicing {

    // MARK: - Injected

    @Injected(\.apiClient)
    private var apiClient: HTTPClient

    // MARK: - Properties

    private var fileManager = FileManager.default

    var localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(Strings.fileName)
    private var appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Strings.appGroupID )?.appendingPathComponent(Strings.appGroupFilePath)

    // MARK: - Methods

    func loadRecording() throws -> AVAsset {
        
        if let localURL = loadFromLocal() {
            return AVURLAsset(url: localURL)
        }
            
        let localURL = try loadFromAppGroup()
        return AVURLAsset(url: localURL)
    }

    func removeRecording() throws {

        guard
            let localURL,
            fileManager.fileExists(atPath: localURL.path)
        else {
            assertionFailure("Could not find recording to remove.")
            return
        }

        try fileManager.removeItem(at: localURL)
    }

    func updateLocalRecording(with path: String) throws -> AVAsset {
        guard
            let localURL,
            fileManager.fileExists(atPath: path)
        else {
            throw FileManagerError.fileNotFound
        }

        if fileManager.fileExists(atPath: localURL.path) {
            try fileManager.removeItem(atPath: localURL.path)
        }

        try fileManager.moveItem(atPath: path, toPath: localURL.path)

        return try loadRecording()
    }

    func uploadRecording() async throws -> RecordingStorage? {

        guard let localData = self.loadLocalData() else {
            return nil
        }

        var multipartRequest = MultipartRequest()
        multipartRequest.add(key: "file", fileName: Strings.fileName, fileMimeType: "video/mp4", fileData: localData)

        return try await apiClient.perform(request: RecordingAPI.uploadRecording(contentType: multipartRequest.httpHeader, body: multipartRequest.httpBody))
    }

    // MARK: - Private Methods

    private func loadFromLocal() -> URL? {
        
        guard
            let localURL,
            fileManager.fileExists(atPath: localURL.path)
        else {
            return nil
        }

        return localURL
    }

    private func loadFromAppGroup() throws -> URL {

        guard
            let appGroupURL,
            let localURL,
            fileManager.fileExists(atPath: appGroupURL.path)
        else {
            throw FileManagerError.fileNotFound
        }

        if fileManager.fileExists(atPath: localURL.path) {
            try fileManager.removeItem(atPath: localURL.path)
        }

        try fileManager.copyItem(at: appGroupURL, to: localURL)
        try fileManager.removeItem(atPath: appGroupURL.path)

        return localURL
    }

    private func loadLocalData() -> Data? {

        guard 
            let localURL,
            fileManager.fileExists(atPath: localURL.path),
            let data = try? Data(contentsOf: localURL)
        else {
            return nil
        }

        return data
    }
}

// MARK: - Strings

private enum Strings {
    static let fileName = "screenRecording.mp4"
    static let appGroupID = "group.org.mozilla.ios.TikTok-Reporter"
    static let appGroupFilePath = "Library/Documents/screenRecording.mp4"
}
