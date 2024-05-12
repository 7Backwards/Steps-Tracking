//
//  StepsChartViewModel.swift
//  mySteps
//
//  Created by Gonçalo on 27/04/2024.
//

import Combine
import Foundation

class StepsChartViewModel {
    
    // MARK: - Properties

    let shouldReloadData = PassthroughSubject<Void, Never>()
    var stepsInMonth: StepsInMonth? {
        didSet {
            shouldReloadData.send()
        }
    }
}
