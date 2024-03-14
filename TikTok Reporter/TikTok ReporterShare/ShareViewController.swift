//
//  ShareViewController.swift
//  TikTok ReporterShare
//
//  Created by Sergiu Ghiran on 20.11.2023.
//

import UIKit
import UniformTypeIdentifiers
import SwiftUI

@objc(ShareViewController)
class ShareViewController: UIViewController {

    // MARK: - Properties

    private lazy var userDefaultsManager = UserDefaultsManager()

    // MARK: - Lifecycle

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard
            userDefaultsManager.getOnboardingStatus(),
            let study = userDefaultsManager.getStudy(),
            let form = study.form
        else {
            self.showAlert(withTitle: Strings.onboardingErrorTitle, description: Strings.onboardingErrorDescription)
            return
        }

        guard
            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first
        else {
            close()
            return
        }

        let dataType = UTType.url.identifier

        if itemProvider.hasItemConformingToTypeIdentifier(dataType) {

            itemProvider.loadItem(forTypeIdentifier: dataType) { (data, error) in

                guard
                    error == nil,
                    let link = (data as? NSURL)?.absoluteString
                else {
                    self.close()
                    return
                }

                DispatchQueue.main.async {

                    let formInputContainer = FormInputMapper.map(form: form)
                    let formViewController = UIHostingController(rootView: FormView(viewModel: .init(formInputContainer: formInputContainer, currentStudy: study, link: link)))

                    self.addChild(formViewController)
                    self.view.addSubview(formViewController.view)

                    formViewController.view.translatesAutoresizingMaskIntoConstraints = false
                
                    NSLayoutConstraint.activate([
                        formViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                        formViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                        formViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                        formViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                    ])
                }
            }
        } else {
            close()
            return
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name(Strings.closeNotificationName), object: nil, queue: nil) { notification in
            guard 
                let success = notification.userInfo?["success"] as? Bool,
                !success
            else {
                self.close()
                return
            }
            
            DispatchQueue.main.async {
                
                self.showAlert(withTitle: Strings.genericErrorTitle, description: Strings.genericErrorDescription)
            }
        }
    }

    // MARK: - Methods

    private func showAlert(withTitle: String, description: String) {

        DispatchQueue.main.async {

            let alertController = UIAlertController(title: withTitle, message: description, preferredStyle: .alert)

            alertController.addAction(UIAlertAction(title: Strings.errorActionTitle, style: .cancel, handler: { _ in
                self.close()
            }))
            
            self.present(alertController, animated: true)
        }
    }

    private func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

private enum Strings {

    // Errors
    static let onboardingErrorTitle = "Go through the onboarding first"
    static let onboardingErrorDescription = "Because this is your first share, please open the TT Reporter app, choose a study, and complete the onboarding process before submitting a report. Thank you!"
    static let genericErrorTitle = "Error"
    static let genericErrorDescription = "Something went wrong, please try again!"
    static let errorActionTitle = "OK"

    // Notification
    static let closeNotificationName = "close"
}
