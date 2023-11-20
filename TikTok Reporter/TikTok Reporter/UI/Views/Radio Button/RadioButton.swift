//
//  RadioButton.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 03.11.2023.
//

import SwiftUI

struct RadioButton: View {

    // MARK: - Properties

    var title: String
    var description: String
    var isActive: Bool
    var isSelected: Bool

    // MARK: - Body

    var body: some View {

        HStack(alignment: .top, spacing: .l) {
            radioCircle
            radioText
        }
    }

    // MARK: - Views

    @ViewBuilder
    private var radioCircle: some View {

        if isSelected {

            ZStack {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(isActive ? .control : .inactive)
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(.invertedText)
            }
        } else {

            Circle()
                .stroke(isActive ? .text : .inactive, lineWidth: 1)
                .frame(width: 20, height: 20)
        }
    }

    private var radioText: some View {

        VStack(alignment: .leading, spacing: .s) {
            Text(title)
                .font(.body1)
                .foregroundStyle(isActive ? .text : .inactive)
                .multilineTextAlignment(.leading)
            Text(description)
                .font(.body2)
                .foregroundStyle(isActive ? .text : .inactive)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    RadioButton(title: "Button", description: "This is a radio button", isActive: false, isSelected: true)
}
