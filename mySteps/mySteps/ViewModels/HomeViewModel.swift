//
//  HomeViewModel.swift
//  mySteps
//
//  Created by Gonçalo on 26/04/2024.
//

import Foundation

class HomeViewModel: ViewModelProtocol {
    let session: Session
    let coordinator: CoordinatorProtocol
    
    init(session: Session, coordinator: CoordinatorProtocol) {
        self.session = session
        self.coordinator = coordinator
    }
    
    func startObservingStepsChanges() {
        session.healthKitManager.startObservingStepsChanges()
    }
    
    func stopObservingStepsChanges() {
        session.healthKitManager.stopObservingStepsChanges()
    }
    
    // Function to compute the achievements with their dates
    func calculateAchievements(from stepsPerDay: [StepsPerDay]) -> [Achievement] {
        var cumulativeSteps: Double = 0
        var achievements: [Achievement] = []

        // Go through each day and check if an achievement threshold has been reached
        for dailySteps in stepsPerDay {
            cumulativeSteps += dailySteps.steps
            
            // Check if the cumulative steps reach any of the achievement thresholds
            if let achievementCase = StepAchievement.allCases.first(where: { Int(cumulativeSteps) >= $0.rawValue }) {
                let achievement = Achievement(achievement: achievementCase, date: dailySteps.date)
                
                // Add the achievement if it has not been added before
                if !achievements.contains(where: { $0.achievement == achievement.achievement }) {
                    achievements.append(achievement)
                }
            }
        }
        return achievements
    }

}
