//
//  UIViewControllerExtension.swift
//  MetaWeather
//
//  Created by DavidMartin on 9/5/21.
//

import SwiftMessages
import SwiftUI

extension UIViewController {
    
    @objc private func forceDismissKeyboard() {
        view.endEditing(true)
    }
    
    func dismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forceDismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    /// Add a SwiftUI `View` as a child of the input `UIView`.
        /// - Parameters:
        ///   - swiftUIView: The SwiftUI `View` to add as a child.
        ///   - view: The `UIView` instance to which the view should be added.
        func addSubSwiftUIView<Content>(_ swiftUIView: Content, to view: UIView) where Content : View {
            let hostingController = UIHostingController(rootView: swiftUIView)

            /// Add as a child of the current view controller.
            addChild(hostingController)

            /// Add the SwiftUI view to the view controller view hierarchy.
            view.addSubview(hostingController.view)

            /// Setup the contraints to update the SwiftUI view boundaries.
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                view.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor),
                view.rightAnchor.constraint(equalTo: hostingController.view.rightAnchor)
            ]

            NSLayoutConstraint.activate(constraints)

            /// Notify the hosting controller that it has been moved to the current view controller.
            hostingController.didMove(toParent: self)
        }
    
    func showMessageBaseOn(type: Theme, message: String) {
        let messageView = MessageView.viewFromNib(layout: .cardView)
        DispatchQueue.main.async {
            switch type {
            case .success:
                messageView.configureTheme(.success)
                // Set message title
                messageView.titleLabel?.text = String.stringByKey(key: .dialogTitleSuccess)
            case .warning:
                messageView.configureTheme(.warning)
                messageView.titleLabel?.text = String.stringByKey(key: .dialogTitleWarning)
            case .error:
                messageView.configureTheme(.error)
                messageView.titleLabel?.text = String.stringByKey(key: .dialogTitleError)
            case .info:
                messageView.configureTheme(.info)
                messageView.titleLabel?.text = String.stringByKey(key: .dialogTitleInfor)
            }
            // Set message content
            messageView.bodyLabel?.text = message
            
            messageView.button?.isHidden = true
            
            var config = SwiftMessages.defaultConfig
            config.presentationStyle = .top
            
            SwiftMessages.show(config: config, view: messageView)
        }
    }
    
    
}
