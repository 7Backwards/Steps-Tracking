//
//  DatabaseManager.swift
//  mySteps
//
//  Created by Gonçalo on 26/04/2024.
//

import Foundation
import Combine
import OSLog

class DatabaseManager {
    
    // MARK: - Properties

    private let coreDataManager: CoreDataManager
    private var cancellables: Set<AnyCancellable> = []
    let stepsInCurrentMonth = CurrentValueSubject<StepsInMonth?, Never>(nil)
    
    // MARK: - Init

    init(coredataManager: CoreDataManager) {
        self.coreDataManager = coredataManager
        setupObservers()
        fetchCurrentMonthSteps()
    }
    
    // MARK: - Public Methods
    
    func saveStepsData(_ stepsData: [Date: Int]) {
        coreDataManager.insertStepsData(stepsData)
    }
    
    // MARK: - Private Methods

    private func setupObservers() {
        coreDataManager.stepsUpdated.sink {
            self.fetchCurrentMonthSteps()
        }
        .store(in: &cancellables)
    }
    
    func fetchCurrentMonthSteps() {
        coreDataManager.fetchStepsForCurrentMonth { [weak self] stepsInMonthMO, error in
            if let stepsInMonthMO {
                self?.stepsInCurrentMonth.send(StepsInMonth(from: stepsInMonthMO))
            } else if let error {
                os_log("Error fetching steps: %{public}@", type: .error, error.localizedDescription)
            }
        }
    }
    
    func checkForExistingSteps(completion: @escaping (Bool) -> Void) {
        coreDataManager.fetchStepsForCurrentMonth { stepsInMonthMO, error in
            if let error = error {
                os_log("Error checking for existing steps data: %{public}@", type: .error, error.localizedDescription)
                completion(false)  // Assume no data if there's an error
            } else {
                // Check if the fetched data is not nil and not empty
                let hasData = stepsInMonthMO != nil
                completion(hasData)
            }
        }
    }
}
