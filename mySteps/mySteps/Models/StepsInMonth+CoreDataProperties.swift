//
//  StepsInMonth+CoreDataProperties.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//
//

import Foundation
import CoreData


extension StepsInMonth {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepsInMonth> {
        return NSFetchRequest<StepsInMonth>(entityName: "StepsInMonth")
    }

    @NSManaged public var days: NSOrderedSet?

}

// MARK: Generated accessors for days
extension StepsInMonth {

    @objc(insertObject:inDaysAtIndex:)
    @NSManaged public func insertIntoDays(_ value: StepsPerDay, at idx: Int)

    @objc(removeObjectFromDaysAtIndex:)
    @NSManaged public func removeFromDays(at idx: Int)

    @objc(insertDays:atIndexes:)
    @NSManaged public func insertIntoDays(_ values: [StepsPerDay], at indexes: NSIndexSet)

    @objc(removeDaysAtIndexes:)
    @NSManaged public func removeFromDays(at indexes: NSIndexSet)

    @objc(replaceObjectInDaysAtIndex:withObject:)
    @NSManaged public func replaceDays(at idx: Int, with value: StepsPerDay)

    @objc(replaceDaysAtIndexes:withDays:)
    @NSManaged public func replaceDays(at indexes: NSIndexSet, with values: [StepsPerDay])

    @objc(addDaysObject:)
    @NSManaged public func addToDays(_ value: StepsPerDay)

    @objc(removeDaysObject:)
    @NSManaged public func removeFromDays(_ value: StepsPerDay)

    @objc(addDays:)
    @NSManaged public func addToDays(_ values: NSOrderedSet)

    @objc(removeDays:)
    @NSManaged public func removeFromDays(_ values: NSOrderedSet)

}

extension StepsInMonth : Identifiable {

}
