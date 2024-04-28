//
//  StepsPerDayMO+CoreDataProperties.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//
//

import Foundation
import CoreData


extension StepsPerDayMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepsPerDayMO> {
        return NSFetchRequest<StepsPerDayMO>(entityName: "StepsPerDayMO")
    }

    @NSManaged public var date: Date
    @NSManaged public var steps: Double
    @NSManaged public var month: StepsInMonthMO?

}

extension StepsPerDayMO : Identifiable {

}
