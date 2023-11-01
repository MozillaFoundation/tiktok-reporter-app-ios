//
//  AlertButtonAction.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 31.10.2023.
//

import Foundation

enum AlertType {
    case info(title: String, description: String)
    case action(title: String, description: String, leftButtonTitle: String, rightButtonTitle: String)

    var title: String {
        switch self {
        case let .info(title, _):
            return title
        case let .action(title, _, _, _):
            return title
        }
    }

    var description: String {
        switch self {
        case let .info(_, description):
            return description
        case let .action(_, description, _, _):
            return description
        }
    }

    var leftButtonTitle: String {
        switch self {
        case .info:
            return "Got it"
        case let .action(_, _, leftButtonTitle, _):
            return leftButtonTitle
        }
    }

    var rightButtonTitle: String? {
        switch self {
        case .info:
            return nil
        case let .action(_, _, _, rightButtonTitle):
            return rightButtonTitle
        }
    }
}
