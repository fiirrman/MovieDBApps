//
//  MovieDBAppsUITests.swift
//  MovieDBAppsUITests
//
//  Created by Firman Aminuddin on 7/16/21.
//

import XCTest

class MovieDBAppsUITests: XCTestCase {
    
//    override func setUp() {
//        continueAfterFailure = false
//        XCUIApplication().launch()
//    }
//
//    override func tearDown() {
//
//    }
//
//    func recApps() throws {
//
//    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.staticTexts["Generate Session"]/*[[".buttons[\"Generate Session\"].staticTexts[\"Generate Session\"]",".staticTexts[\"Generate Session\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts.scrollViews.otherElements.buttons["OK"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Documentary"]/*[[".cells.staticTexts[\"Documentary\"]",".staticTexts[\"Documentary\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Family"]/*[[".cells.staticTexts[\"Family\"]",".staticTexts[\"Family\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Action"]/*[[".cells.staticTexts[\"Action\"]",".staticTexts[\"Action\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Release Date : 2021-06-09"]/*[[".cells.staticTexts[\"Release Date : 2021-06-09\"]",".staticTexts[\"Release Date : 2021-06-09\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Release Date : 2021-05-14"]/*[[".cells.staticTexts[\"Release Date : 2021-05-14\"]",".staticTexts[\"Release Date : 2021-05-14\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Black Widow"]/*[[".cells.staticTexts[\"Black Widow\"]",".staticTexts[\"Black Widow\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Movie Detail"].buttons["Genre : Action"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Release Date : -"]/*[[".cells.staticTexts[\"Release Date : -\"]",".staticTexts[\"Release Date : -\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app.navigationBars["Genre : Action"].buttons["Movie Genre List"].tap()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
