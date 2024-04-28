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
}
