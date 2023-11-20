//
//  PresentationStateView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 01.11.2023.
//

import SwiftUI

struct PresentationStateView<ViewModel: PresentationStateObject, Content: View>: View {

    // MARK: - Properties

    @ObservedObject
    private var viewModel: ViewModel

    private var content: Content

    // MARK: - Lifecycle

    init(viewModel: ViewModel, @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.content = content()
    }

    // MARK: - Body

    var body: some View {

        GeometryReader { reader in

            switch viewModel.state {
            case .failed:
                // TODO: - Add error
                Text("Error")
            case .idle:
                IdleView()
            case .loading:
                LoadingView()
                    .frame(width: reader.size.width, height: reader.size.height)
            case .success:
                content
                    .frame(width: reader.size.width)
            }
        }
    }
}
