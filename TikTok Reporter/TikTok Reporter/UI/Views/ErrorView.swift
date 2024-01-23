//
//  ErrorView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 29.11.2023.
//

import SwiftUI

struct ErrorView: View {

    // MARK: - Properties

    @Binding
    var shouldReload: Bool
    
    @State
    var isErrorNetworkRelated: Bool = false
    
    @State
    var error: Error?

    
    
    // MARK: - Body

    var body: some View {
        
        ZStack {
            ZStack(alignment: .center) {
                
                VStack(spacing: .xl) {

                    Image(.error)
                    
                    if !isErrorNetworkRelated {
                        Text("Ups! Something went wrong")
                            .font(.heading3)
                            .foregroundStyle(.text)

                        Text("The system doesn’t seem to respond. Our cat must have been chewing the wires again.")
                            .font(.heading5)
                            .foregroundStyle(.text)
                            .multilineTextAlignment(.center)

                        Text("Please forgive Tom and try again later.")
                            .font(.heading5)
                            .foregroundStyle(.text)
                            .multilineTextAlignment(.center)
                    } else {
                        Text(Values.noInternetConnectionTitle)
                            .font(.heading3)
                            .foregroundStyle(.text)
                    }
                }
                .padding(.xl)
            }

            VStack {
                Spacer()
                MainButton(text: "Refresh", type: .secondary) {
                    shouldReload = true
                }
                .padding(.horizontal, .xl)
            }
        }
        .onAppear(perform: {
            checkErrorCodeIfNetworkOperated()
        })
    }
    
    
    func checkErrorCodeIfNetworkOperated() {
        guard let failedError = error as? NSError,
              failedError.code == Values.networkOperationErrorCode else {
            isErrorNetworkRelated = false
            return
        }
        isErrorNetworkRelated = true
    }
    
    enum Values {
        static let networkOperationErrorCode = -1009
        static let noInternetConnectionTitle = "Oops! No Internet connection"
    }
    
}

// MARK: - Preview

#Preview {
    ErrorView(shouldReload: .constant(false), error: NSError(domain: "", code: 1))
}
