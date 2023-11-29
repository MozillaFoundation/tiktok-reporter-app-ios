//
//  FormTab.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 29.11.2023.
//

import Foundation

enum FormTab: Equatable {

    case reportLink
    case recordSession

    var tabTitle: String {

        switch self {
        case .reportLink:
            return "Report a link"
        case .recordSession:
            return "Record a session"
        }
    }
}
