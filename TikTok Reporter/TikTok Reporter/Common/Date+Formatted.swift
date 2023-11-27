//
//  Date+Formatted.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 27.11.2023.
//

import Foundation

extension Date {

    func formattedString() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy at HH:mm"

        return dateFormatter.string(from: self)
    }
}
