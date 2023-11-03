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
                // Temporary until we receive logo from Mozilla.
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image(systemName: "play.rectangle")
                        Text("TikTok Reporter").font(.heading5)
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

                Text("Select a study to participate in")
                    .font(.heading3)
                    .foregroundStyle(.text)
                Text("We may choose to run a few different studies simultaneously. These are the studies available to you based on the information you provided.")
                    .font(.body2)
                    .foregroundStyle(.text)
                radioButtons
            }
            .padding(.xl)
        }
    }
    
    private var nextButton: some View {
        MainButton(text: "Next", type: .secondary) {
            // TODO: - Add action
        }
        .padding(.horizontal, .xl)
    }
    
    private var radioButtons: some View {
        RadioButtonGroup(selection: $viewModel.selected, options: viewModel.studies) { isSelected, study in
            RadioButton(title: study?.name ?? "", description: study?.description ?? "", isActive: study?.isActive ?? true, isSelected: isSelected)
        }
    }
}

#Preview {
    StudySelectionView(viewModel: .init())
}
