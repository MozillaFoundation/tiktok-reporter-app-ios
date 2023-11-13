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
        NavigationView {
            PresentationStateView(viewModel: self.viewModel) {
                self.content
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image(.header)
                    }
                }
            }
        }
        .onAppear {
            viewModel.load()
        }
    }
    
    // MARK: - Views
    
    private var content: some View {
        VStack {
            studies
            nextButton
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
    }
}

#Preview {
    StudySelectionView(viewModel: .init(appState: AppStateManager()))
}
