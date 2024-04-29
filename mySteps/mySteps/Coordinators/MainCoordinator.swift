//
//  MainCoordinator.swift
//  mySteps
//
//  Created by Gonçalo on 26/04/2024.
//

import Foundation
import UIKit

class MainCoordinator: CoordinatorProtocol {

    // MARK: - Properties

    var presentedCoordinator: CoordinatorProtocol?
    var presentedViewController: UIViewController?
    var navigationController: UINavigationController
    var session: Session

    // MARK: - Init

    init(navigationController: UINavigationController, session: Session) {
        self.navigationController = navigationController
        self.session = session
    }

    // MARK: - Public Methods

    func start() {

        let homeViewModel = HomeViewModel(session: session, coordinator: self)
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        presentedViewController = homeViewController
        navigationController.pushViewController(homeViewController, animated: true)
    }
    
    func showAchievement(_ achievement: Achievement) {

        guard let presentedViewController else {
            return
        }
        
        let achievementViewController = AchievementViewController(achievement: achievement)
        
        self.navigationController.pushViewController(achievementViewController, animated: true)
    }
}
