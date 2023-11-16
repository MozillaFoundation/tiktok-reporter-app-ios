//
//  StudySelectionView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 02.11.2023.
//

import SwiftUI

struct StudySelectionView: View {
    
    // MARK: - Properties
    
    @ObservedObject
    var viewModel: ViewModel
    
    // MARK: - Body
    
    var body: some View {
//        NavigationView {
            PresentationStateView(viewModel: self.viewModel) {
                self.content
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Image(.header)
                }
            }
//        }
        .onAppear {
            viewModel.load()
        }
        .customAlert(
            title: "Change study?",
            description: "Are you sure you want to enroll in another study?",
            isPresented: $viewModel.routingState.alert,
            secondaryButton: {
                MainButton(text: "Cancel", type: .secondary) {
                    viewModel.resetSelected()
                    viewModel.routingState.alert = false
                }
            },
            primaryButton: {
                MainButton(text: "Yes", type: .primary) {
                    viewModel.saveStudy()
                    viewModel.routingState.alert = false
                }
            }
        )
    }
    
    // MARK: - Views
    
    private var content: some View {
        VStack {
            studies
            if viewModel.viewState == .empty {
                nextButton
            }
        }
    }
    
    private var studies: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: .xl) {
                studyTitle
                studyDescription
                radioButtons
            }
            .padding(.xl)
        }
    }
    
    private var studyTitle: some View {
        Text("Select a study to participate in")
            .font(.heading3)
            .foregroundStyle(.text)
    }
    
    private var studyDescription: some View {
        Text("We may choose to run a few different studies simultaneously. These are the studies available to you based on the information you provided.")
            .font(.body2)
            .foregroundStyle(.text)
    }
    
    private var nextButton: some View {
        MainButton(text: "Next", type: .secondary) {
            viewModel.saveStudy()
        }
        .padding([.horizontal, .bottom], .xl)
    }
    
    private var radioButtons: some View {
        RadioButtonGroup(selection: $viewModel.selected, options: viewModel.studies) { isSelected, study in
            RadioButton(title: study?.name ?? "", description: study?.description ?? "", isActive: study?.isActive ?? true, isSelected: isSelected)
        }
        .onChange(of: viewModel.selected) { [oldValue = viewModel.selected] newValue in
            guard viewModel.viewState != .empty, oldValue?.id ?? "" == viewModel.prefilledStudy?.id ?? "" else {
                return
            }
            
            viewModel.tempStudy = oldValue
            viewModel.routingState.alert = true
        }
    }
}

#Preview {
    StudySelectionView(viewModel: .init(appState: AppStateManager()))
}
