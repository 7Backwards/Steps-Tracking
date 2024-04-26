//
//  MainCoordinator.swift
//  mySteps
//
//  Created by Gonçalo on 26/04/2024.
//

import Foundation
import UIKit

class MainCoordinator: CoordinatorProtocol {

    var presentedCoordinator: CoordinatorProtocol?
    var presentedViewController: UIViewController?
    var navigationController: UINavigationController
    var session: Session

    init(navigationController: UINavigationController, session: Session) {
        self.navigationController = navigationController
        self.session = session
    }

    func start() {

        let homeViewModel = HomeViewModel(session: session, coordinator: self)
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        presentedViewController = homeViewController
        navigationController.pushViewController(homeViewController, animated: true)
    }
}
