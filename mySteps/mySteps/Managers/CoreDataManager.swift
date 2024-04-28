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
                // Check if StepsInMonthMO objects are affected and notify if necessary
                let StepsInMonthMOAffected = context.registeredObjects.contains { object in
                    object is StepsInMonthMO && (object.isUpdated || object.isInserted || object.isDeleted)
                }
                try context.save()

                if StepsInMonthMOAffected {
                    stepsUpdated.send()
                    print("stepsUpdated")
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
    
    func insertStepsData(_ stepsData: [Date: Double]) {
        persistentContainer.performBackgroundTask { [weak self] context in
            self?.clearStepsData(in: context)
            
            // Map the [Date: Double] dictionary to a month and its corresponding steps
            let groupedByMonth = Dictionary(grouping: stepsData.keys) { Calendar.current.dateComponents([.year, .month], from: $0) }
            
            // Loop through the grouped data to insert
            for (monthComponents, dates) in groupedByMonth {
                let StepsInMonthMO = StepsInMonthMO(context: context)
                guard let year = monthComponents.year, let month = monthComponents.month else { 
                    os_log("Error retreving year or month", type: .error)
                    return
                } 
                StepsInMonthMO.year = Int16(year) 
                StepsInMonthMO.month = Int16(month)
                
                for date in dates {
                    let steps = stepsData[date] ?? 0
                    let StepsPerDayMO = StepsPerDayMO(context: context)
                    StepsPerDayMO.date = date
                    StepsPerDayMO.steps = steps
                    StepsPerDayMO.month = StepsInMonthMO // Link StepsPerDayMO to StepsInMonthMO
                }
            }
            
            // Save the new steps data
            self?.saveContext(context: context)
        }
    }
    
    // MARK: - Private methods
    
    private func clearStepsData(in context: NSManagedObjectContext) {
        
        // Create fetch requests for the entities you want to clear
        let StepsPerDayMOFetchRequest: NSFetchRequest<NSFetchRequestResult> = StepsPerDayMO.fetchRequest()
        let StepsInMonthMOFetchRequest: NSFetchRequest<NSFetchRequestResult> = StepsInMonthMO.fetchRequest()
        
        // Create batch delete requests for each entity
        let StepsPerDayMODeleteRequest = NSBatchDeleteRequest(fetchRequest: StepsPerDayMOFetchRequest)
        let StepsInMonthMODeleteRequest = NSBatchDeleteRequest(fetchRequest: StepsInMonthMOFetchRequest)
        
        do {
            // Perform the batch delete operation
            try context.execute(StepsPerDayMODeleteRequest)
            try context.execute(StepsInMonthMODeleteRequest)
            
            // Save any changes to the context
            try context.save()
        } catch {
            // Handle any errors here, such as logging or presenting an alert to the user
            os_log("Error clearing steps data: %{public}@", type: .error, error.localizedDescription)
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
                  let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
                completion(nil, NSError(domain: "CoreDataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to construct the date range for the current month."]))
                return
            }
            
            // Create a predicate to fetch the StepsInMonthMO for the current year and month
            fetchRequest.predicate = NSPredicate(format: "year == %d AND month == %d", Int16(calendar.component(.year, from: startOfMonth)), Int16(calendar.component(.month, from: startOfMonth)))
            
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
