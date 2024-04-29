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
    var totalSteps: Double = 0
    
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
        var cumulativeSteps = 0
        var achievements: [Achievement] = []

        for dailySteps in stepsPerDay {
            cumulativeSteps += Int(dailySteps.steps)

            let newAchievements = StepAchievement.allCases.filter { achievementCase in
                cumulativeSteps >= achievementCase.rawValue &&
                !achievements.contains(where: { $0.achievement == achievementCase })
            }
            
            for achievementCase in newAchievements {
                let achievement = Achievement(achievement: achievementCase, date: dailySteps.date)
                achievements.append(achievement)
            }
        }
        
        return achievements
    }
}
