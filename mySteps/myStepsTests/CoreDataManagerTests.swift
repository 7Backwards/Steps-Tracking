//
//  DatabaseManagerTests.swift
//  myStepsTests
//
//  Created by Gonçalo on 30/04/2024.
//

import XCTest
import CoreData
import Combine
@testable import mySteps

class CoreDataManagerTests: XCTestCase {
    var sut: CoreDataManager!
    var mockPersistentContainer: NSPersistentContainer!
    private var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        mockPersistentContainer = createMockPersistentContainer()
        sut = CoreDataManager()
        sut.persistentContainer = mockPersistentContainer
    }

    override func tearDown() {
        sut = nil
        mockPersistentContainer = nil
        super.tearDown()
    }

    func createMockPersistentContainer() -> NSPersistentContainer {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: "mySteps")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load in-memory database: \(error)")
            }
        }
        return container
    }
    
    func testInsertStepsData_NotifiesWhenDataChanges() {
        let expectation = self.expectation(description: "Steps updated")
        var stepsData = [Date: Int]()
        stepsData[Date()] = 10000

        sut.stepsUpdated.sink(receiveValue: {
            expectation.fulfill()
        }).store(in: &subscriptions)

        sut.insertStepsData(stepsData)

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testClearObsoleteData_RemovesDataNotForCurrentMonth() {
        // Insert some test data for previous months and the current month
        insertTestData(for: Date())
        insertTestData(for: Calendar.current.date(byAdding: .month, value: -1, to: Date())!)

        // Perform the clear obsolete data operation
        let context = mockPersistentContainer.viewContext
        context.performAndWait {
            sut.clearObsoleteStepsData(in: context)
        }

        // Fetch remaining data and check that only current month's data is present
        let fetchRequest: NSFetchRequest<StepsInMonthMO> = StepsInMonthMO.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1, "There should be only one month data present.")
            let currentMonth = Calendar.current.component(.month, from: Date())
            let currentYear = Calendar.current.component(.year, from: Date())
            XCTAssertTrue(results.allSatisfy { $0.year == Int16(currentYear) && $0.month == Int16(currentMonth) }, "Remaining data should be for the current month.")
        } catch {
            XCTFail("Failed to fetch StepsInMonthMO entities: \(error)")
        }
    }
    
    private func insertTestData(for date: Date) {
        let context = mockPersistentContainer.newBackgroundContext()
        context.performAndWait {
            let newStepsInMonthMO = StepsInMonthMO(context: context)
            newStepsInMonthMO.year = Int16(Calendar.current.component(.year, from: date))
            newStepsInMonthMO.month = Int16(Calendar.current.component(.month, from: date))
            
            do {
                try context.save()
            } catch {
                XCTFail("Failed to insert test data: \(error)")
            }
        }
    }
    
}
