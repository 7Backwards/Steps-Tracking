//
//  CoordinatorProtocol.swift
//  mySteps
//
//  Created by Gonçalo on 26/04/2024.
//

import Foundation
import UIKit

protocol CoordinatorProtocol {

    var presentedCoordinator: CoordinatorProtocol? { get set }

    var navigationController: UINavigationController { get set }

    var presentedViewController: UIViewController? { get set }

    var session: Session { get set }

    // Starts the coordinator by presenting the viewController
    func start()

}
