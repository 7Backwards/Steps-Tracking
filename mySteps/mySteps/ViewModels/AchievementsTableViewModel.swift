//
//  ArchivementsViewModel.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//

import Foundation
import Combine

import UIKit

class AchievementsTableViewModel {
    
    let shouldReloadData = PassthroughSubject<Void, Never>()
    
    var achievements: [Achievement] = [] {
        didSet {
            shouldReloadData.send()
        }
    }
}
