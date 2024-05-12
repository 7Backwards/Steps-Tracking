//
//  StepsInMonthMO+CoreDataClass.swift
//  mySteps
//
//  Created by Gonçalo on 28/04/2024.
//
//

import Foundation
import CoreData

@objc(StepsInMonthMO)
public class StepsInMonthMO: NSManagedObject {
    @NSManaged public var month: Int32
    @NSManaged public var year: Int32
}
