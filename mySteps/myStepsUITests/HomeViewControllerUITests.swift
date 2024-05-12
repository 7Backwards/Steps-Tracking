//
//  myStepsUITests.swift
//  myStepsUITests
//
//  Created by Gonçalo on 26/04/2024.
//

import XCTest

class HomeViewControllerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testStepsAndDateDisplay() {
        let stepsLabel = app.staticTexts["stepsCountLabel"]
        let dateLabel = app.staticTexts["dateLabel"]

        XCTAssertTrue(stepsLabel.exists, "Steps label should be visible.")
        XCTAssertTrue(dateLabel.exists, "Date label should be visible.")
        XCTAssertGreaterThan(stepsLabel.label.count, 0, "Steps label should have a value.")
    }

    func testAchievementsDisplay() {
        let achievementsLabel = app.staticTexts["achievementsLabel"]
        XCTAssertTrue(achievementsLabel.exists, "Achievements label should be visible.")
        XCTAssertTrue(achievementsLabel.label.contains("Achievements"), "Achievements label should contain text 'Achievements'.")

        let achievementsCollectionView = app.collectionViews["achievementsCollectionView"]
        XCTAssertTrue(achievementsCollectionView.exists, "Achievements collection view should be visible.")
    }
    
    func testScrollViewScrolling() {
        let scrollView = app.scrollViews.element(boundBy: 0)
        scrollView.swipeUp()
        scrollView.swipeDown()
        XCTAssertTrue(scrollView.exists, "ScrollView should be scrollable.")
    }
    
    func testStepsChartVisibility() {
        let stepsChart = app.otherElements["stepsChart"]
        XCTAssertTrue(stepsChart.exists, "Steps chart should be visible on the home screen.")
    }
}
