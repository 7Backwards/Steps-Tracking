//
//  StepsInMonth+CoreDataClass.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//
//

import Foundation
import CoreData

@objc(StepsInMonth)
public class StepsInMonth: NSManagedObject {
    @NSManaged public var month: Int16
    @NSManaged public var year: Int16
}
