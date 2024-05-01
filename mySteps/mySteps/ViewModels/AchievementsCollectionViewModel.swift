//
//  ArchivementsViewModel.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//

import Foundation
import Combine

import UIKit

class AchievementsCollectionViewModel {
    
    // MARK: - Properties

    let shouldReloadData = PassthroughSubject<Void, Never>()
    let cellWidthSize: CGFloat = 116
    let cellHeightSize: CGFloat = 160
    
    var achievements: [Achievement] = [] {
        didSet {
            shouldReloadData.send()
        }
    }
}
