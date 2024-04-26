//
//  Session.swift
//  mySteps
//
//  Created by Gonçalo on 26/04/2024.
//

import Foundation

class Session {

    // MARK: Properties

    let constants: Constants
    let healthKitManager: HealthKitManager
    let databaseManager: DatabaseManager

    // MARK: Lifecycle

    init(constants: Constants, healthKitManager: HealthKitManager, databaseManager: DatabaseManager) {
        self.constants = constants
        self.healthKitManager = healthKitManager
        self.databaseManager = databaseManager
    }
}
