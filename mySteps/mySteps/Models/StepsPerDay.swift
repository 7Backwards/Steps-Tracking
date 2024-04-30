//
//  StepsPerDay.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//

import Foundation
import OSLog

struct StepsPerDay {
    let date: Date
    let steps: Int
    
    init(from managedObject: StepsPerDayMO) {
        os_log("Initializing StepsPerDay with managedObject %@", type: .info, managedObject)
        self.date = managedObject.date
        self.steps = Int(managedObject.steps)
    }
}
