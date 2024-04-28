//
//  StepsInMonthMO+CoreDataProperties.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//
//

import Foundation
import CoreData


extension StepsInMonthMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepsInMonthMO> {
        return NSFetchRequest<StepsInMonthMO>(entityName: "StepsInMonthMO")
    }

    @NSManaged public var days: NSOrderedSet?

}

// MARK: Generated accessors for days
extension StepsInMonthMO {

    @objc(insertObject:inDaysAtIndex:)
    @NSManaged public func insertIntoDays(_ value: StepsPerDayMO, at idx: Int)

    @objc(removeObjectFromDaysAtIndex:)
    @NSManaged public func removeFromDays(at idx: Int)

    @objc(insertDays:atIndexes:)
    @NSManaged public func insertIntoDays(_ values: [StepsPerDayMO], at indexes: NSIndexSet)

    @objc(removeDaysAtIndexes:)
    @NSManaged public func removeFromDays(at indexes: NSIndexSet)

    @objc(replaceObjectInDaysAtIndex:withObject:)
    @NSManaged public func replaceDays(at idx: Int, with value: StepsPerDayMO)

    @objc(replaceDaysAtIndexes:withDays:)
    @NSManaged public func replaceDays(at indexes: NSIndexSet, with values: [StepsPerDayMO])

    @objc(addDaysObject:)
    @NSManaged public func addToDays(_ value: StepsPerDayMO)

    @objc(removeDaysObject:)
    @NSManaged public func removeFromDays(_ value: StepsPerDayMO)

    @objc(addDays:)
    @NSManaged public func addToDays(_ values: NSOrderedSet)

    @objc(removeDays:)
    @NSManaged public func removeFromDays(_ values: NSOrderedSet)

}

extension StepsInMonthMO : Identifiable {

}
