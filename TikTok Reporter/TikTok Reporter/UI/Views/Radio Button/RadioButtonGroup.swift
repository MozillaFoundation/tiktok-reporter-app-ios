//
//  RadioButtonGroup.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 02.11.2023.
//

import SwiftUI

protocol Enabling {
    var isActive: Bool { get }
}

struct RadioButtonGroup<Option, RadioButton>: View where Option: Hashable, RadioButton: View {

    // MARK: - Properties

    @Binding
    var selection: Option
    var options: [Option]
    
    @ViewBuilder
    var radioButton: (Bool, Option) -> RadioButton

    // MARK: - Lifecycle

    init(selection: Binding<Option>, options: [Option], radioButton: @escaping (Bool, Option) -> RadioButton) {
        self._selection = selection
        self.options = options
        self.radioButton = radioButton
    }

    // MARK: - Body

    var body: some View {
        ForEach(options, id: \.self) { option in
            Button(action: {
                selection = option
            }, label: {
                radioButton(selection == option, option)
            })
            .disabled(isDisabled(option))
        }
    }

    // MARK: - Methods

    private func isDisabled(_ option: Option) -> Bool {
        if let enabling = option as? Enabling {
            return !enabling.isActive
        }

        return false
    }
}
