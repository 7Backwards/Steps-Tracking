//
//  ViewModelProtocol.swift
//  mySteps
//
//  Created by Gonçalo on 26/04/2024.
//

import Foundation

protocol ViewModelProtocol {
    var session: Session { get }
    var coordinator: CoordinatorProtocol { get }
}
