//
//  GleanManager.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 06.12.2023.
//

import Foundation
import Glean

final class GleanManager {

    // MARK: - MetricType

    enum MetricType {
        case email, identifier, fields
    }

    // MARK: - Methods

    static func submitUUID(_ uuid: UUID) {

        GleanMetrics.TiktokReport.identifier.set(uuid)
        GleanMetrics.Pings.shared.tiktokRequest.submit()
    }

    static func submitText(_ text: String, metricType: MetricType) {

        switch metricType {
        case .email:
            GleanMetrics.TiktokReport.email.set(text)
        case .fields:
            GleanMetrics.TiktokReport.fields.set(text)
        default:
            break
        }

        GleanMetrics.Pings.shared.tiktokRequest.submit()
    }
}
