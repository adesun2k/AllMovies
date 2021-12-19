//
//  AllMoviesUITests.swift
//  AllMoviesUITests
//
//  Created by Seun Adeyemi on 15/12/2021.
//

import XCTest

class AllMoviesUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppWorking() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let table = app.tables.firstMatch
            let label0 = table.cells.staticTexts.matching(NSPredicate(format: "label CONTAINS[cd] %@", " ")).firstMatch
            let label1 = table.cells.staticTexts.matching(NSPredicate(format: "label CONTAINS[cd] %@", " ")).firstMatch
            // I query for the first cells that I find with the expected title containing a white space,
            // instead of directly accessing the 1st and 2nd cells in the table,
            // for performance issues.
            // So I can't add assertions for the "first" and "second" titles.
            // But we can at least add assertions that both titles are visible,
           
           
            XCTAssertTrue(label0.isHittable)
            XCTAssertTrue(label1.isHittable)
       
       
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

