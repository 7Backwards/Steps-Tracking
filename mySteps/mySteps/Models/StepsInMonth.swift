//
//  StepsInMonth.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//

import Foundation
import OSLog

struct StepsInMonth {
    let days: [StepsPerDay]
    let month: Int32
    let year: Int32
    
    init(from managedObject: StepsInMonthMO) {
        os_log("Initializing StepsInMonth with managedObject %@", type: .info, managedObject)
        // 'days' is a CoreData ordered set
        if let daysSet = managedObject.days?.array as? [StepsPerDayMO] {
            let mappedDays = daysSet.map { StepsPerDay(from: $0) }
            self.days = mappedDays.sorted(by: { $0.date < $1.date })
        } else {
            self.days = []
        }
        
        self.month = managedObject.month
        self.year = managedObject.year
    }
}

extension StepsInMonth {

    func getTotalSteps() -> Int {
        // Sum the steps for each day to get the total for the month.
        days.reduce(0) { $0 + $1.steps }
    }
    
    func getFormattedTotalSteps() -> String {
        let totalSteps = getTotalSteps()
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        
        if let formattedTotalSteps = formatter.string(from: NSNumber(value: totalSteps)) {
            return formattedTotalSteps
        } else {
            return "\(totalSteps)"
        }
    }
}
