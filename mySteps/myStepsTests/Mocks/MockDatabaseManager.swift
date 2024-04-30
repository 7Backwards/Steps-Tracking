//
//  MockDatabaseManager.swift
//  myStepsTests
//
//  Created by Gonçalo on 30/04/2024.
//

import Foundation
import mySteps
@testable import mySteps

class MockDatabaseManager: DatabaseManager {
    var saveCalled = false

    override func saveStepsData(_ data: [Date: Int]) {
        saveCalled = true
    }

    func checkForExistingSteps(completion: (Bool) -> Void) {
        completion(true) // Simulate existing data
    }
}
