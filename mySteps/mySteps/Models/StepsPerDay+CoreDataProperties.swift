//
//  StepsPerDay+CoreDataProperties.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//
//

import Foundation
import CoreData


extension StepsPerDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepsPerDay> {
        return NSFetchRequest<StepsPerDay>(entityName: "StepsPerDay")
    }

    @NSManaged public var date: Date
    @NSManaged public var steps: Double
    @NSManaged public var month: StepsInMonth?

}

extension StepsPerDay : Identifiable {

}
