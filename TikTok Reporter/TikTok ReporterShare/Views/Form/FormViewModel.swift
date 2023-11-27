//
//  FormViewModel.swift
//  TikTok ReporterShare
//
//  Created by Sergiu Ghiran on 21.11.2023.
//

import SwiftUI

extension FormView {

    // MARK: - ViewModel

    final class ViewModel: PresentationStateObject {

        // MARK: - Properties

        private(set) var otherId: String? = nil
        private(set) var otherFieldId: String? = nil
        
        private var userDefaultsManager = UserDefaultsManager()

        private var currentStudy: Study
        private var link: String

        @Published
        var formUIContainer: FormUIContainer

        @Published
        var state: PresentationState = .idle
    
        private lazy var otherField: FormUIRepresentable = {

            return FormUIRepresentable(formItem: FormItem(id: "", label: nil, description: nil, isRequired: true, field: .textField(TextFieldFormField(placeholder: Strings.otherFieldPlaceholder, maxLines: 1, multiline: false))))
        }()

        // MARK: - Lifecycle

        init(formUIContainer: FormUIContainer, currentStudy: Study, link: String) {

            self.formUIContainer = formUIContainer
            self.currentStudy = currentStudy
            self.link = link

            self.formUIContainer.items.forEach { formItem in

                if case let .dropDown(fieldItem) = formItem.formItem.field, fieldItem.hasOtherOption {
                    self.otherFieldId = formItem.id
                    self.otherId = fieldItem.options.first(where: { $0.title.lowercased() == Strings.otherTitle })?.id
                }
            }
        
            self.load()
            self.preFillLink()
        }

        // MARK: - Methods

        func load() {
            state = .loading

            guard let url = URL(string: Strings.studiesURL) else {
                state = .failed
                NotificationCenter.default.post(name: NSNotification.Name(Strings.closeNotificationName), object: nil)
                return
            }

            var urlRequest = URLRequest(url: url)

            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpMethod = "GET"
            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData

            Task {
                do {
                    let (data, response) = try await URLSession.shared.data(for: urlRequest)
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 400

                    guard 
                        statusCode == 200,
                        let apiStudies = try? JSONDecoder().decode([Study].self, from: data),
                        apiStudies.contains(where: { $0.id == currentStudy.id && $0.isActive })
                    else {
                        state = .failed
                        NotificationCenter.default.post(name: NSNotification.Name(Strings.closeNotificationName), object: nil)
                        return
                    }

                    state = .success
                }
            }
        }

        func preFillLink() {
            guard formUIContainer.items.count > 0 else {
                return
            }

            formUIContainer.items[0].stringValue = link
            formUIContainer.items[0].isEnabled = false
        }

        func insertOther() {
            guard
                let otherFieldId = otherFieldId,
                let dropDownIndex = formUIContainer.items.firstIndex(where: { $0.formItem.id == otherFieldId })
            else {
                return
            }

            formUIContainer.items.insert(otherField, at: dropDownIndex + 1)
        }

        func removeOther() {
            guard let otherFieldIndex = formUIContainer.items.firstIndex(of: otherField) else {
                return
            }

            formUIContainer.items.remove(at: otherFieldIndex)
        }
    }
}

// MARK: - Strings

private enum Strings {
    static let otherFieldPlaceholder = "Suggest a category"
    static let otherTitle = "other"
    static let studiesURL = "https://tiktok-reporter-app-be-jbrlktowcq-ew.a.run.app/studies/by-country-code"
    static let closeNotificationName = "close"
}
