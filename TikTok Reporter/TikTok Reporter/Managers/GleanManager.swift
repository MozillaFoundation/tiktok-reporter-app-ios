//
//  GleanManager.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 06.12.2023.
//

import Foundation
import Glean

protocol GleanManaging {
    func setup(isMainProcess: Bool)
    func setEmail(_ email: String)
    func setIdentifier(_ identifier: UUID)
    func setFields(_ fields: String)
    func setScreenRecording(_ screenRecording: String)
    func submit()
}

final class GleanManager: GleanManaging {

    // MARK: - Lifecycle

    init() {
        Glean.shared.setDebugViewTag("tiktokreport-iOS")
        Glean.shared.setLogPings(true)

        Glean.shared.registerPings(GleanMetrics.Pings.shared)
    }

    // MARK: - Setup

    func setup(isMainProcess: Bool) {

//        if isMainProcess {
//
//            Glean.shared.initialize(uploadEnabled: true, buildInfo: GleanMetrics.GleanBuild.info)
//        } else {

            guard
                let appGroupContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Strings.appGroupID)
            else {
                fatalError("could not get shared app group directory.")
            }

            let dataPath = appGroupContainer.path + "/glean_data"

            let configuration = Configuration(dataPath: dataPath)
            Glean.shared.initialize(uploadEnabled: true, configuration: configuration, buildInfo: GleanMetrics.GleanBuild.info)
//        }
    }

    // MARK: - Email

    func setEmail(_ email: String) {
        GleanMetrics.TiktokReport.email.set(email)
    }

    // MARK: - Identifier

    func setIdentifier(_ identifier: UUID) {
        GleanMetrics.TiktokReport.identifier.set(identifier)
    }

    // MARK: - Fields

    func setFields(_ fields: String) {
        GleanMetrics.TiktokReport.fields.set(fields)
    }

    // MARK: - Screen Recording

    func setScreenRecording(_ screenRecording: String) {
        GleanMetrics.TiktokReport.screenRecording.set(screenRecording)
    }

    // MARK: - Submit

    func submit() {
        GleanMetrics.Pings.shared.tiktokReport.submit()
    }
}

// MARK: - Strings

private enum Strings {
    // App Group
    static let appGroupID = "group.org.mozilla.ios.TikTok-Reporter"
}
