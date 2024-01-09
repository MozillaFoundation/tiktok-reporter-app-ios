//
//  ScreenRecording.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 29.11.2023.
//

import UIKit
import AVFoundation

struct ScreenRecording {

    // MARK: - Properties

    private(set) var asset: AVAsset

    private(set) var thumbnail: UIImage?
    private(set) var duration: CMTime = .zero
    private(set) var recordingDate: Date? = nil

    // MARK: - Lifecycle

    init(asset: AVAsset) {
        self.asset = asset
    }

    // MARK: - Methods

    mutating func loadMetadata() async throws {
        self.duration = try await asset.load(.duration)
        self.recordingDate = try await asset.load(.creationDate)?.load(.dateValue)
    }

    mutating func setThumbnail(_ thumbnail: UIImage) {
        self.thumbnail = thumbnail
    }
}
