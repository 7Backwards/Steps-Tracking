//
//  AchievementsCellViewModel.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//

import Foundation
import UIKit

class AchievementsCellViewModel {
    let steps: String
    let date: Date
    let image: UIImage?

    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }

    // Initialize the view model with the necessary data
    init(date: Date, steps: String, image: UIImage?) {
        self.date = date
        self.steps = steps
        self.image = image
    }
}
