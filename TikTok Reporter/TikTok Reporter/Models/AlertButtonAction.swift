//
//  AlertButtonAction.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 31.10.2023.
//

import Foundation

//enum AlertType {
//    case info(title: String, description: String)
//    case action(title: String, description: String)
//
//    var title: String {
//        switch self {
//        case let .info(title, _, _):
//            return title
//        case let .action(title, _, _, _, _, _):
//            return title
//        }
//    }
//
//    var description: String {
//        switch self {
//        case let .info(_, description, _):
//            return description
//        case let .action(_, description, _, _, _, _):
//            return description
//        }
//    }
//
//    var leftButtonTitle: String {
//        switch self {
//        case .info:
//            return "Got it"
//        case let .action(_, _, leftButtonTitle, _, _, _):
//            return leftButtonTitle
//        }
//    }
//
//    var rightButtonTitle: String? {
//        switch self {
//        case .info:
//            return nil
//        case let .action(_, _, _, rightButtonTitle, _, _):
//            return rightButtonTitle
//        }
//    }
//
//    var leftAction: (() -> ())? {
//        switch self {
//        case let .info(_, _, action):
//            return action
//        case let .action(_, _, _, _, action, _):
//            return action
//        }
//    }
//
//    var rightAction: (() -> ())? {
//        if case let .action(_, _, _, _, _, action) = self {
//            return action
//        }
//
//        return nil
//    }
//}
