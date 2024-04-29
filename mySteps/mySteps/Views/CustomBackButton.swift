//
//  CustomBackButton.swift
//  mySteps
//
//  Created by Gonçalo on 29/04/2024.
//

import UIKit

protocol CustomBackButtonProtocol: UIGestureRecognizerDelegate {
    func setupCustomBackButton(forModal isModal: Bool)
}

extension CustomBackButtonProtocol where Self: UIViewController {
    func setupCustomBackButton(forModal isModal: Bool = false) {
        navigationItem.leftBarButtonItem = BackBarButtonItem(modalPresentation: isModal, action: UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

class BackBarButtonItem: UIBarButtonItem {
    
    init(modalPresentation: Bool, action: UIAction) {
        super.init()

        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arrow.backward")
        let buttonSize = CGSize(width: 44, height: 45)
        let backButton = UIButton(configuration: config, primaryAction: action)
        backButton.frame = CGRect(origin: CGPoint.zero, size: buttonSize)
        backButton.tintColor = .darkGray
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: buttonSize.width),
            backButton.heightAnchor.constraint(equalToConstant: buttonSize.height)
        ])
        
        customView = backButton
        accessibilityLabel = "Back Button"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}