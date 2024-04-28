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
    
    // MARK: - Init

    init(coredataManager: CoreDataManager) {
        self.coreDataManager = coredataManager
        setupObservers()
    }
    
    // MARK: - Public Methods
    
    func saveStepsData(_ stepsData: [Date: Double]) {
        coreDataManager.insertStepsData(stepsData)
    }
    
    // MARK: - Private Methods

    private func setupObservers() {
        coreDataManager.stepsUpdated.sink {
            self.fetchCurrentMonthSteps()
        }
        .store(in: &cancellables)
    }
    
    private func fetchCurrentMonthSteps() {
        coreDataManager.fetchStepsForCurrentMonth { stepsInMonthMO, error in
            if let stepsInMonthMO {
                let stepsInMonth = StepsInMonth(from: stepsInMonthMO)
            } else if let error {
                os_log("Error fetching steps: %{public}@", type: .error, error.localizedDescription)
            }
        }
    }
}
