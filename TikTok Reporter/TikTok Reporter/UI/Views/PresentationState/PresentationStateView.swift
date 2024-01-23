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
    @State
    private var shouldReload: Bool = false

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
            case .failed(let error):
                ErrorView(shouldReload: $shouldReload, error: error)
                    .onChange(of: shouldReload) { shouldReload in
                        guard shouldReload else {
                            return
                        }

                        viewModel.load()
                        self.shouldReload = false
                    }
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
