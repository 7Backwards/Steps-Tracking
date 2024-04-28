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
                // Check if StepsInMonth objects are affected and notify if necessary
                let stepsInMonthAffected = context.registeredObjects.contains { object in
                    object is StepsInMonth && (object.isUpdated || object.isInserted || object.isDeleted)
                }
                try context.save()

                if stepsInMonthAffected {
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
                let stepsInMonth = StepsInMonth(context: context)
                guard let year = monthComponents.year, let month = monthComponents.month else { 
                    os_log("Error retreving year or month", type: .error)
                    return
                } 
                stepsInMonth.year = Int16(year) 
                stepsInMonth.month = Int16(month)
                
                for date in dates {
                    let steps = stepsData[date] ?? 0
                    let stepsPerDay = StepsPerDay(context: context)
                    stepsPerDay.date = date
                    stepsPerDay.steps = steps
                    stepsPerDay.month = stepsInMonth // Link StepsPerDay to StepsInMonth
                }
            }
            
            // Save the new steps data
            self?.saveContext(context: context)
        }
    }
    
    // MARK: - Private methods
    
    private func clearStepsData(in context: NSManagedObjectContext) {
        
        // Create fetch requests for the entities you want to clear
        let stepsPerDayFetchRequest: NSFetchRequest<NSFetchRequestResult> = StepsPerDay.fetchRequest()
        let stepsInMonthFetchRequest: NSFetchRequest<NSFetchRequestResult> = StepsInMonth.fetchRequest()
        
        // Create batch delete requests for each entity
        let stepsPerDayDeleteRequest = NSBatchDeleteRequest(fetchRequest: stepsPerDayFetchRequest)
        let stepsInMonthDeleteRequest = NSBatchDeleteRequest(fetchRequest: stepsInMonthFetchRequest)
        
        do {
            // Perform the batch delete operation
            try context.execute(stepsPerDayDeleteRequest)
            try context.execute(stepsInMonthDeleteRequest)
            
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
    
    func fetchStepsForCurrentMonth(completion: @escaping ([StepsPerDay]?, Error?) -> Void) {
        
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<StepsInMonth> = StepsInMonth.fetchRequest()
            
            // Get the current year and month
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: Date())
            guard let year = components.year, let month = components.month else {
                completion(nil, NSError(domain: "CoreDataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to extract the year and month from the current date."]))
                return
            }
            
            // Create a predicate to fetch the StepsInMonth for the current year and month
            fetchRequest.predicate = NSPredicate(format: "year == %d AND month == %d", Int16(year), Int16(month))
            
            do {
                // Execute the fetch request
                let results = try context.fetch(fetchRequest)
                // Assuming there is at most one StepsInMonth entity per month
                if let stepsInMonth = results.first {
                    // Get the ordered steps from the StepsInMonth.days relationship
                    let stepsArray = stepsInMonth.days?.array as? [StepsPerDay] ?? []
                    completion(stepsArray, nil)
                } else {
                    // No StepsInMonth entity found for this month, return an empty array
                    completion([], nil)
                }
            } catch {
                completion(nil, error)
            }
        }
    }
}
