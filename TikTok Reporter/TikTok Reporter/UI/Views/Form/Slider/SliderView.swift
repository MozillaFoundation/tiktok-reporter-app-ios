//
//  SliderView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 09.11.2023.
//

import SwiftUI

struct SliderView: View {
    
    // MARK: - Properties
    
    @Binding
    var value: Double

    var max: Double
    var step: Double
    var leftLabel: String
    var rightLabel: String
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Slider(value: $value, in: 0...max, step: step)
                .tint(.basicRed)
            HStack {
                Text(leftLabel)
                    .font(.body2)
                    .foregroundStyle(.text)
                Spacer()
                Text(rightLabel)
                    .font(.body2)
                    .foregroundStyle(.text)
            }
        }
        .padding(.horizontal, .s)
    }
}

#Preview {
    SliderView(value: .constant(0.0), max: 100.0, step: 10.0, leftLabel: "0.0", rightLabel: "100.0")
}
