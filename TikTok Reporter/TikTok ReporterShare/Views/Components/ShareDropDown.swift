//
//  ShareDropDown.swift
//  TikTok ReporterShare
//
//  Created by Sergiu Ghiran on 21.11.2023.
//

import SwiftUI

struct ShareDropDown: View {
    
    // MARK: - Properties
    
    @Binding
    var selected: String
    @Binding
    var isValid: Bool

    var options: [DropDownOption]
    var placeholder: String
    
    // MARK: - Body

    var body: some View {

        Menu {
            picker
        } label: {
            VStack(alignment: .leading) {
                pickerLabel

                if !isValid {
                    errorLabel
                }
            }
        }
    }

    // MARK: - Views

    private var picker: some View {

        Picker(placeholder, selection: $selected) {
            ForEach(options) { option in
                Text(option.title)
                    .tag(option.id)
            }
        }
        .onChange(of: selected) { _ in
            isValid = true
        }
    }

    private var pickerLabel: some View {

            HStack {
                Text(selectedTitle(with: selected))
                    .font(.body1)
                    .foregroundStyle(.text)
                    .padding(.leading, .m)
                Spacer()
                Image(systemName: "chevron.down")
                    .padding(.trailing, .m)
            }
            .frame(height: 40.0)
            .border(isValid ? .text : .error, width: 1.0)
        .tint(.text)
    }

    private var errorLabel: some View {

        HStack {
            Text("This field cannot be empty")
                .font(.body2)
                .foregroundStyle(.error)
            Spacer()
        }
    }

    // MARK: - Methods

    private func selectedTitle(with id: String) -> String {
        return options.first(where: { $0.id == id })?.title ?? placeholder
    }
}

#Preview {
    ShareDropDown(selected: .constant("Option"), isValid: .constant(true), options: [DropDownOption(id: "1", title: "Option 1"), DropDownOption(id: "2", title: "Option 2")], placeholder: "Category")
}

