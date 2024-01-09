//
//  UserDefaultsManager.swift
//  TikTok ReporterShare
//
//  Created by Sergiu Ghiran on 21.11.2023.
//

import Foundation

final class UserDefaultsManager {

    // MARK: - Keys

    enum Keys: String {
        case study
        case hasCompletedOnboarding
        case link
    }

    // MARK: - UserDefaults

    private var userDefaults = UserDefaults(suiteName: Strings.appGroupID)

    // MARK: - Methods

    func getOnboardingStatus() -> Bool {

        guard
            let data = userDefaults?.data(forKey: Keys.hasCompletedOnboarding.rawValue),
            let hasCompletedOnboarding = try? JSONDecoder().decode(Bool.self, from: data)
        else {
            return false
        }

        return hasCompletedOnboarding
    }

    func getStudy() -> Study? {

        guard
            let data = userDefaults?.data(forKey: Keys.study.rawValue),
            let study = try? JSONDecoder().decode(Study.self, from: data)
        else {
            return nil
        }

        return study
    }

    func setLink(_ link: String?) {
        userDefaults?.setValue(link, forKey: Keys.link.rawValue)
    }

    func getLink() -> String? {
        guard let tikTokLink = userDefaults?.value(forKey: Keys.link.rawValue) as? String else {
            return nil
        }

        return tikTokLink
    }
}

// MARK: - Strings

private enum Strings {
    // App Group
    static let appGroupID = "group.org.mozilla.ios.TikTok-Reporter"
}
