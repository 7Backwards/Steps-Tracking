//
//  HealthKitManager.swift
//  mySteps
//
//  Created by Gonçalo on 27/04/2024.
//

import Foundation
import Combine
import HealthKit
import OSLog

enum HealthKitManagerStatus {
    case observing
    case stopped
    case noPermissions
    case initial
}

class HealthKitManager {
    
    // MARK: - Properties
    
    let databaseManager: DatabaseManager
    var status = CurrentValueSubject<HealthKitManagerStatus, Never>(.initial)
    private var subscriptions: [AnyCancellable] = []
    private let stepType: HKQuantityType? = HKQuantityType.quantityType(forIdentifier: .stepCount)
    private let healthStore = HKHealthStore()
    private var observerQuery: HKObserverQuery?
    
    
    // MARK: - Init

    init(databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager

        guard let stepType else {
            os_log("Error getting stepType", type: .error)
            return
        }
        
        let typesToRead: Set = [stepType]
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { [weak self] success, error in
            self?.status.value = success ? .stopped : .noPermissions
        }
    }
    
    // MARK: - Public Methods
    
    // Method to start observing step count changes
    func startObservingStepsChanges() {
        guard let stepType else {
            os_log("Error getting stepType", type: .error)
            return
        }
        
        // Handle case where user hasn't granted permissions yet
        guard status.value != .initial else {
            status
                .first { $0 != .initial }
                .sink { [weak self] status in
                self?.startObservingStepsChanges()
            }
            .store(in: &subscriptions)
            return
        }

        observerQuery = HKObserverQuery(sampleType: stepType, predicate: nil) { [weak self] query, completionHandler, error in
            if let error {
                os_log("Error while observing HealthKit changes: %{public}@", type: .error, error.localizedDescription)

                if let hkError = error as? HKError, hkError.code == .errorAuthorizationDenied {
                    self?.status.send(.noPermissions)
                }
                return
            }
            
            // Data has changed, so fetch the latest steps data if needed
            self?.fetchAndSaveStepsForCurrentMonth()
            
            // Call the completion handler to let HealthKit know we have finished processing the update
            completionHandler()
        }
        
        guard let observerQuery else {
            os_log("Unexpected error while unwrapping variable that should always be non nil", type: .error)
            return
        }
        
        // Execute the observer query
        healthStore.execute(observerQuery)
        status.send(.observing)
    }
    
    // Method to stop observing step count changes
    func stopObservingStepsChanges() {
        if let query = observerQuery {
            healthStore.stop(query)
            observerQuery = nil
            status.send(.stopped)
        }
    }
    
    // Method to fetch the latest steps data and save it to core data
    func fetchAndSaveStepsForCurrentMonth() {

        // Use the current calendar to find the start and end of the month
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month], from: now)
        guard 
            let startOfMonth = calendar.date(from: components),
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)
        else {
            os_log("Error getting startOfMonth or endOfMonth", type: .error)
            return
        }
        
        // Create the predicate for the query
        let predicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: endOfMonth, options: .strictStartDate)
        
        guard let stepType else {
            os_log("Error getting stepType", type: .error)
            return
        }
        
        // Define the query to fetch steps per day
        let query = HKStatisticsCollectionQuery(quantityType: stepType,
                                                quantitySamplePredicate: predicate,
                                                options: .cumulativeSum,
                                                anchorDate: startOfMonth,
                                                intervalComponents: DateComponents(day: 1))
        
        // Set the results handler for the query
        query.initialResultsHandler = { [weak self] query, results, error in
            if let error {
                os_log("HealthKit Query Error: %{public}@", type: .error, error.localizedDescription)
            }
            
            guard let statsCollection = results else {
                os_log("HealthKit Query Failed: The query returned no results.", type: .error)
                return
            }
            
            // Dictionary to hold the number of steps for each day
            var stepsPerDayMO: [Date: Int] = [:]
            
            // Enumerate through the collection and store the total steps for each day
            statsCollection.enumerateStatistics(from: startOfMonth, to: now) { statistics, stop in
                let date = statistics.startDate
                let steps = statistics.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
                stepsPerDayMO[date] = Int(steps)
            }

            let allStepsAreZero = stepsPerDayMO.allSatisfy { $0.value == 0 }

            // We can assume that we dont have permission to read healthkit steps info, since per documentation the app cannot determine whether or not a user has granted permission to read data. If we are not given permission, it simply appears as if there is no data of the requested type in the HealthKit store.
            if allStepsAreZero {
                self?.status.send(.noPermissions)
                self?.databaseManager.checkForExistingSteps { hasStepsData in
                    if !hasStepsData {
                        self?.databaseManager.saveStepsData(stepsPerDayMO)
                    }
                }
            } else {
                self?.databaseManager.saveStepsData(stepsPerDayMO)
            }
        }
        
        // Execute the query
        healthStore.execute(query)
    }
}
