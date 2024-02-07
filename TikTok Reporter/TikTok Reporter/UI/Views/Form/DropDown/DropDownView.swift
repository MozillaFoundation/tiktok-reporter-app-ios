//
//  DropDownView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 09.11.2023.
//

import SwiftUI

struct DropDownView: View {
    
    // MARK: - Properties
    
    @Binding
    var selected: String
    @Binding
    var isValid: Bool

    @State var options: [DropDownOption]
    var placeholder: String
    
    var hasOtherOption: Bool
    
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
        .onAppear {
            checkDropdownHasOtherOption()
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
    
    private func checkDropdownHasOtherOption() {
        guard hasOtherOption else {
            return
        }
        
        guard let _ = options.firstIndex(where: { $0.id == "-otherDropdownItem" }) else {
            options.append(DropDownOption(id: "-otherDropdownItem", title: "Other"))
            return
        }
        
    }

    private var pickerLabel: some View {

            HStack {

                Text(selectedTitle(with: selected))
                    .font(.body1)
                    .foregroundStyle(.text)
                    .padding(.leading, .m)

                Spacer()

                Image(.chevronDown)
                    .padding(.trailing, .m)
            }
            .frame(height: 40.0)
            .border(isValid ? .text : .error, width: 1.0)
        .tint(.text)
    }

    private var errorLabel: some View {

        HStack {
            Text(Strings.errorMessage)
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

// MARK: - Preview

#Preview {
    DropDownView(selected: .constant("Option"), isValid: .constant(true), 
                 options: [DropDownOption(id: "1", title: "Option 1"),
                           DropDownOption(id: "2", title: "Option 2")],
                 placeholder: "Category",
                 hasOtherOption: true)
}

// MARK: - Strings

private enum Strings {
    static let errorMessage = "This field cannot be empty"
}
