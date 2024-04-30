//
//  CoreDataManager.swift
//  mySteps
//
//  Created by Gonçalo on 27/04/2024.
//

import Foundation
import CoreData
import Combine
import OSLog

class CoreDataManager {
    // MARK: - Properties
    
    var stepsUpdated = PassthroughSubject<Void, Never>()

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "mySteps")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support

    func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                // Check if StepsPerDayMO objects are affected and notify if necessary
                let stepsPerDayAffected = context.registeredObjects.contains { object in
                    object is StepsPerDayMO && (object.isUpdated || object.isInserted || object.isDeleted)
                }
                try context.save()

                if stepsPerDayAffected {
                    stepsUpdated.send()
                    os_log("stepsUpdated", type: .debug)
                }
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Extension (Insert)

extension CoreDataManager {
    
    // MARK: - Public Methods
    
    func insertStepsData(_ stepsData: [Date: Int]) {
        persistentContainer.performBackgroundTask { [weak self] context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            // Fetch existing data or clear data that's no longer needed
            self?.clearObsoleteStepsData(in: context)

            let groupedByMonth = Dictionary(grouping: stepsData.keys) { Calendar.current.dateComponents([.year, .month], from: $0) }

            for (monthComponents, dates) in groupedByMonth {
                guard let year = monthComponents.year, let month = monthComponents.month else { 
                    os_log("Error retrieving year or month", type: .error)
                    return
                } 

                let fetchRequest: NSFetchRequest<StepsInMonthMO> = StepsInMonthMO.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "year == %d AND month == %d", year, month)
                
                let existingMonthEntry = (try? context.fetch(fetchRequest))?.first

                let stepsInMonthMO = existingMonthEntry ?? StepsInMonthMO(context: context)
                if existingMonthEntry == nil {
                    stepsInMonthMO.year = Int32(year)
                    stepsInMonthMO.month = Int32(month)
                }
                
                for steps in stepsData {
                    print("new steps \(steps.key) \(steps.value)")
                }
                
                for date in dates {
                    let steps = stepsData[date] ?? 0

                    let fetchRequestPerDay: NSFetchRequest<StepsPerDayMO> = StepsPerDayMO.fetchRequest()
                    fetchRequestPerDay.predicate = NSPredicate(format: "date == %@", date as NSDate)
                    
                    let existingDayEntry = (try? context.fetch(fetchRequestPerDay))?.first
                    
                    let stepsPerDayMO = existingDayEntry ?? StepsPerDayMO(context: context)
                    if existingDayEntry == nil {
                        stepsPerDayMO.date = date
                        stepsPerDayMO.month = stepsInMonthMO // Link StepsPerDayMO to StepsInMonthMO
                    }

                    stepsPerDayMO.steps = Int32(steps)
                }
            }

            // Save the new or updated steps data
            self?.saveContext(context: context)
        }
    }

    func clearObsoleteStepsData(in context: NSManagedObjectContext) {
        let calendar = Calendar.current
        let now = Date()
        let currentComponents = calendar.dateComponents([.year, .month], from: now)
        
        guard let currentYear = currentComponents.year, let currentMonth = currentComponents.month else {
            os_log("Current year and month could not be retrieved", type: .error)
            return
        }

        let fetchRequest: NSFetchRequest<StepsInMonthMO> = StepsInMonthMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "year != %d OR month != %d", currentYear, currentMonth)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                print("deleted object \(object.month) \(object.year)")
                context.delete(object)
            }
            try context.save()
            os_log("Obsolete steps data cleared.", type: .info)
        } catch let error as NSError {
            os_log("Could not clear obsolete steps data: %@", type: .error, error.localizedDescription)
        }
    }
}

// MARK: - Extension (Fetch)

extension CoreDataManager {
    
    func fetchStepsForCurrentMonth(completion: @escaping (StepsInMonthMO?, Error?) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<StepsInMonthMO> = StepsInMonthMO.fetchRequest()

            // Get the current year and month
            let calendar = Calendar.current
            let now = Date()
            guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)),
                  let endOfMonth = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: now) else {
                completion(nil, NSError(domain: "CoreDataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to construct the date range for the current month."]))
                return
            }
            
            // Create a predicate to fetch the StepsInMonthMO for the current year and month
            fetchRequest.predicate = NSPredicate(format: "year == %d AND month == %d", Int32(calendar.component(.year, from: startOfMonth)), Int32(calendar.component(.month, from: startOfMonth)))
            
            do {
                // Execute the fetch request
                let results = try context.fetch(fetchRequest)
                // Assuming there is at most one StepsInMonthMO entity per month
                if let stepsInMonthMO = results.first {
                    // Check if the fetched steps are within the current month
                    if let steps = stepsInMonthMO.days?.array as? [StepsPerDayMO],
                       steps.allSatisfy({ step in
                           step.date >= startOfMonth && step.date < calendar.date(byAdding: .day, value: 1, to: endOfMonth)!
                       }) {
                        completion(stepsInMonthMO, nil)
                    } else {
                        // The fetched entity does not have steps within the current month
                        completion(nil, nil)
                    }
                } else {
                    // No StepsInMonthMO entity found for this month
                    completion(nil, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
    }
}
