//
//  StepsInMonth.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//

import Foundation

struct StepsInMonth {
    let days: [StepsPerDay]
    let month: Int16
    let year: Int16
    
    init(from managedObject: StepsInMonthMO) {
        
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
