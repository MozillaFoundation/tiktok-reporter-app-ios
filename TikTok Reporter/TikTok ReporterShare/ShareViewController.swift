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
            self.showAlert(withTitle: "Go through the onboarding first", description: "Because this is your first share, please open the TikTok Reporter app, choose a study, and complete the onboarding process before submitting a report. Thank you!")
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

                    let formUIContainer = FormUIMapper.map(form: form)
                    let formViewController = UIHostingController(rootView: FormView(viewModel: .init(formUIContainer: formUIContainer, currentStudy: study, link: link)))

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

        NotificationCenter.default.addObserver(forName: NSNotification.Name("close"), object: nil, queue: nil) { _ in
            DispatchQueue.main.async {
                self.showAlert(withTitle: "Error", description: "Something went wrong, please try again!")
            }
        }
    }

    // MARK: - Methods

    private func showAlert(withTitle: String, description: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: withTitle, message: description, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                self.close()
            }))
            
            self.present(alertController, animated: true)
        }
    }

    private func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
