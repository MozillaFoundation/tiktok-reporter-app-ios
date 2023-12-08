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
        
        // MARK: - Properties
        
        private(set) var form: Form
        private(set) var appState: AppStateManager
        
        @Published
        var state: PresentationState = .success
        @Published
        var routingState: Routing = .init()
        @Published
        var formUIContainer: FormInputContainer
        @Published
        var didUpdateMainField: Bool = false
        
        // MARK: - Lifecycle
        
        init(form: Form, appState: AppStateManager) {

            self.form = form
            self.appState = appState
            
            self.formUIContainer = FormUIMapper.map(form: form)

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
                    // TODO: - Remove before release
                    apiStudies?.append(TestStudyProvider.study)
                    
                    try await MainActor.run {
                        if let studies = apiStudies, !studies.contains(where: { $0.id == study.id && $0.isActive }) {
                            try appState.save(false, for: .hasCompletedOnboarding)
                        }
                        
                        state = .success
                    }
                } catch {
                    state = .failed
                    print(error.localizedDescription)
                }
            }
        }

        func sendReport() {
            guard
                formUIContainer.validate(),
                let studyId = appState.study?.id,
                let uuid = UUID(uuidString: studyId)
            else {
                return
            }

            do {

                let jsonForm = try FormJSONMapper.map(self.formUIContainer)
                GleanManager.submitText(jsonForm, metricType: .fields)
                // TODO: - Should we send these at once or sequentially?
                GleanManager.submitUUID(uuid)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    
        func cancelReport() {
            formUIContainer.items[0].stringValue = ""
            formUIContainer.items[0].isEnabled = true
            
            didUpdateMainField = false
        }
    }
}
