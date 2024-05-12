//
//  MockHealthStore.swift
//  myStepsTests
//
//  Created by Gonçalo on 30/04/2024.
//

import Foundation
import HealthKit

class MockHealthStore: HKHealthStore {
    var authorizationRequested = false
    var executeCalled = false
    var stopCalled = false
    
    override func execute(_ query: HKQuery) {
        executeCalled = true
    }
    
    override func stop(_ query: HKQuery) {
        stopCalled = true
    }
    
    override func requestAuthorization(toShare typesToShare: Set<HKSampleType>?, read typesToRead: Set<HKObjectType>?, completion: @escaping (Bool, Error?) -> Void) {
        authorizationRequested = true
        // Simulate authorization failure
        completion(false, nil)
    }
    
}
