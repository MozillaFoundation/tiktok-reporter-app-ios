//
//  GleanManager.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 06.12.2023.
//

import Foundation
import Glean

protocol GleanManaging {
    func setup()
    func setEmail(_ email: String, identifier: UUID)
    func setFields(_ fields: String, identifier: UUID)
    func setScreenRecording(_ screenRecording: String, identifier: UUID)
    func setDownloadData(email: String, identifier: UUID)
    func setDeleteData()
    func submit()
    func submitEmail()
    func submitScreenRecording()
    func submitDownloadData()
}

final class GleanManager: GleanManaging {

    // MARK: - Lifecycle

    init() {
        Glean.shared.setDebugViewTag("tiktokreport-iOS")
        Glean.shared.setLogPings(true)

        Glean.shared.registerPings(GleanMetrics.Pings.shared)
    }

    // MARK: - Setup

    func setup() {

        guard
            let appGroupContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Strings.appGroupID)
        else {
            fatalError("could not get shared app group directory.")
        }
        
        let dataPath = appGroupContainer.path + "/glean_data"
        
        let configuration = Configuration(dataPath: dataPath)
        Glean.shared.initialize(uploadEnabled: true, configuration: configuration, buildInfo: GleanMetrics.GleanBuild.info)
    }

    // MARK: - Email

    func setEmail(_ email: String, identifier: UUID) {
        GleanMetrics.Email.email.set(email)
        GleanMetrics.Email.identifier.set(identifier)
    }

    // MARK: - Fields

    func setFields(_ fields: String, identifier: UUID) {
        GleanMetrics.TiktokReport.fields.set(fields)
        GleanMetrics.TiktokReport.identifier.set(identifier)
    }

    // MARK: - Screen Recording

    func setScreenRecording(_ screenRecording: String, identifier: UUID) {
        GleanMetrics.TiktokScreenRecording.data.set(screenRecording)
        GleanMetrics.TiktokScreenRecording.identifier.set(identifier)
    }

    // MARK: - Download Data

    func setDownloadData(email: String, identifier: UUID) {
        GleanMetrics.DownloadData.email.set(email)
        GleanMetrics.DownloadData.identifier.set(identifier)
    }

    // MARK: - Delete Data

    func setDeleteData() {
        Glean.shared.setUploadEnabled(false)
        Glean.shared.setUploadEnabled(true)
    }

    // MARK: - Submit

    func submit() {
        GleanMetrics.Pings.shared.tiktokReport.submit()
    }
    
    func submitEmail() {
        GleanMetrics.Pings.shared.email.submit()
    }
    
    func submitScreenRecording() {
        GleanMetrics.Pings.shared.screenRecording.submit()
    }
    
    func submitDownloadData() {
        GleanMetrics.Pings.shared.downloadData.submit()
    }
}

// MARK: - Strings

private enum Strings {
    // App Group
    static let appGroupID = "group.org.mozilla.ios.TikTok-Reporter"
}
