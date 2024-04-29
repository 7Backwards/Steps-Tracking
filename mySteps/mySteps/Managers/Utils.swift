//
//  Utils.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//

import Foundation

class Utils {
    func getCurrentMonthYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let currentMonthYear = dateFormatter.string(from: Date())
        return currentMonthYear
    }
}
