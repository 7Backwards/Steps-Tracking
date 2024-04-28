//
//  StepAchievement.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//

import UIKit

// Struct to manage each achievement and its associated date
struct Achievement {
    let achievement: StepAchievement
    let date: Date
    
    var steps: Int {
        achievement.rawValue
    }
    
    var image: UIImage? {
        achievement.image
    }
}

// Enum with associated values
enum StepAchievement: Int, CaseIterable {
    case tenK = 10_000
    case fifteenK = 15_000
    case twentyK = 20_000
    case twentyFiveK = 25_000
    case thirtyK = 30_000
    case thirtyFiveK = 35_000
    case fortyK = 40_000
    
    var image: UIImage? {
        switch self {
        case .tenK:
            return UIImage(named: "achievement-10k")
        case .fifteenK:
            return UIImage(named: "achievement-15k")
        case .twentyK:
            return UIImage(named: "achievement-20k")
        case .twentyFiveK:
            return UIImage(named: "achievement-25k")
        case .thirtyK:
            return UIImage(named: "achievement-30k")
        case .thirtyFiveK:
            return UIImage(named: "achievement-35k")
        case .fortyK:
            return UIImage(named: "achievement-40k")
        }
    }
    
    var description: String {
        let formattedStepCount = NumberFormatter.localizedString(from: NSNumber(value: self.rawValue), number: .decimal)
        return "\(formattedStepCount) Steps achievement"
    }
}
