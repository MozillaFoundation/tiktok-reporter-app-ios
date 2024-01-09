//
//  CMTime+Positional.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 27.11.2023.
//

import Foundation
import CoreMedia

extension CMTime {

    var positionalTime: String {
        let roundedSeconds = seconds.rounded()

        let minutes = Int(roundedSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(roundedSeconds.truncatingRemainder(dividingBy: 60))

        return String(format: "%02d:%02d", minutes, seconds)
    }
}
