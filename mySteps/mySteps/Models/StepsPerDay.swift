//
//  StepsPerDay.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//

import Foundation

struct StepsPerDay {
    let date: Date
    let steps: Int
    
    init(from managedObject: StepsPerDayMO) {
        self.date = managedObject.date
        self.steps = Int(managedObject.steps)
    }
}
