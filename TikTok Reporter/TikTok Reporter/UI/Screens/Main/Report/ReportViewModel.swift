//
//  ReportViewModel.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 13.11.2023.
//

import SwiftUI
import AVFoundation

extension ReportView {

    // MARK: - Routing

    struct Routing {
        var submissionResult: Bool = false
    }
    
    // MARK: - ViewModel
    
    final class ViewModel: PresentationStateObject {
        
        // MARK: - Injected
        
        @Injected(\.studiesService)
        private var studiesService: StudiesServicing
        @Injected(\.gleanManager)
        private var gleanManager: GleanManaging
        
        // MARK: - Properties
        
        private(set) var form: Form
        private(set) var appState: AppStateManager

        private(set) var otherId: String? = nil
        private(set) var otherFieldId: String? = nil
        
        @Published
        var formShouldScrollToNotValidatedScope: Bool = false
        
        @Published
        var state: PresentationState = .success
        @Published
        var routingState: Routing = .init()
        @Published
        var formInputContainer: FormInputContainer
        @Published
        var didUpdateMainField: Bool = false

        private lazy var otherField: FormInputField = {

            return FormInputField(formItem: FormItem(id: "other", label: nil, description: nil, isRequired: true, field: .textField(TextFieldFormField(placeholder: Strings.otherFieldTitle, maxLines: 1, multiline: false))))
        }()
        
        // MARK: - Lifecycle
        
        init(form: Form, appState: AppStateManager) {

            self.form = form
            self.appState = appState
            
            self.formInputContainer = FormInputMapper.map(form: form)
            self.setupFormItems()

            self.load()
        }
        
        // MARK: - Methods
        
        func load() {

            guard let study = appState.study else {
                return
            }
            
            state = .loading
            
            Task {
                do {
                    var apiStudies: [Study]? = try await studiesService.getStudies()
                    
                    try await MainActor.run {
                        if let studies = apiStudies, !studies.contains(where: { $0.id == study.id && $0.isActive }) {
                            try appState.save(false, for: .hasCompletedOnboarding)
                        }
                        
                        state = .success
                    }
                } catch {
                    state = .failed(error)
                    print(error.localizedDescription)
                }
            }
        }

        func sendReport() {
            guard formInputContainer.validate() else {
                formShouldScrollToNotValidatedScope = true
                return
            }
            
            guard
                let studyId = appState.study?.id,
                let uuid = UUID(uuidString: studyId)
            else {
                return
            }

            do {

                let jsonForm = try JSONMapper.map(self.formInputContainer)

                gleanManager.setFields(jsonForm, identifier: uuid)
                gleanManager.submit()

                cancelReport()
                routingState.submissionResult = true
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    
        func cancelReport() {
            formInputContainer.reset()
            didUpdateMainField = false
        }

        // MARK: - Private Methods

        private func setupFormItems() {

            self.formInputContainer.items.forEach { formItem in

                if case let .dropDown(fieldItem) = formItem.formItem.field, fieldItem.hasOtherOption {
                    self.otherFieldId = formItem.id
                    self.otherId = fieldItem.options.first(where: { $0.title.lowercased() == Strings.otherTitle })?.id
                }
            }
        }
    }
}

// MARK: - Strings

private enum Strings {
    static let otherFieldTitle = "Suggest a category"
    static let otherTitle = "other"
}
