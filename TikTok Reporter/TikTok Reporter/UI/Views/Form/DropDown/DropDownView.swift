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
    var options: [DropDownOption]
    var placeholder: String
    
    // MARK: - Body

    var body: some View {

        Menu {
            Picker(placeholder, selection: $selected) {
                ForEach(options) { option in
                    Text(option.title)
                        .tag(option.id)
                }
            }
        } label: {
            ZStack(alignment: .leading) {
                Rectangle()
                    .stroke()
                    .frame(height: 40.0)
                HStack {
                    Text(selectedTitle(with: selected))
                        .font(.body1)
                        .foregroundStyle(.text)
                        .padding(.leading, .m)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .padding(.trailing, .m)
                }
            }
            .tint(.text)

        }
    }

    // MARK: - Methods

    private func selectedTitle(with id: String) -> String {
        return options.first(where: { $0.id == id })?.title ?? ""
    }
}

#Preview {
    DropDownView(selected: .constant("Option"), options: [DropDownOption(id: "1", title: "Option 1"), DropDownOption(id: "2", title: "Option 2")], placeholder: "Category")
}
