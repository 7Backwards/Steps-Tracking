//
//  StepsPerDay.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//

import Foundation

struct StepsPerDay {
    let date: Date
    let steps: Double
    
    init(from managedObject: StepsPerDayMO) {
        self.date = managedObject.date
        self.steps = managedObject.steps
    }
}
