//
//  AchievementsViewModel.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//

import Foundation
import UIKit

class AchievementsViewModel {

    // MARK: - Properties
    
    let achievement: Achievement
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dMMM") // Template for abbreviated month and day
        return dateFormatter.string(from: achievement.date)
    }

    // MARK: - Init

    init(achievement: Achievement) {
        self.achievement = achievement
    }
}
