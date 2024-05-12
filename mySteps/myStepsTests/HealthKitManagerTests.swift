//
//  myStepsTests.swift
//  myStepsTests
//
//  Created by Gonçalo on 26/04/2024.
//

import XCTest
@testable import mySteps

final class HealthKitManagerTests: XCTestCase {
    
    func testInit_RequestsAuthorization() {
        let mockHealthStore = MockHealthStore()
        let _ = HealthKitManager(databaseManager: MockDatabaseManager(coredataManager: CoreDataManager()), healthStore: mockHealthStore)
        // Verify that authorization is requested
        XCTAssertTrue(mockHealthStore.authorizationRequested)
    }
    
    func testStartObservingStepsChanges_ExecutesQuery() {
        let mockHealthStore = MockHealthStore()
        let manager = HealthKitManager(databaseManager: MockDatabaseManager(coredataManager: CoreDataManager()), healthStore: mockHealthStore)
        manager.startObservingStepsChanges()
        XCTAssertTrue(mockHealthStore.executeCalled)
    }
    
    func testStopObservingStepsChanges_StopsQuery() {
        let mockHealthStore = MockHealthStore()
        let manager = HealthKitManager(databaseManager: MockDatabaseManager(coredataManager: CoreDataManager()), healthStore: mockHealthStore)
        manager.startObservingStepsChanges()
        manager.stopObservingStepsChanges()
        XCTAssertTrue(mockHealthStore.stopCalled)
    }
    
    func testPermissions_NotGranted_SetsStatus() {
        let mockHealthStore = MockHealthStore()
        let manager = HealthKitManager(databaseManager: MockDatabaseManager(coredataManager: CoreDataManager()), healthStore: mockHealthStore)
        // Simulate permission denied scenario
        mockHealthStore.requestAuthorization(toShare: nil, read: nil) { granted, error in
        }
        
        XCTAssertEqual(manager.status.value, .noPermissions)
    }
}
