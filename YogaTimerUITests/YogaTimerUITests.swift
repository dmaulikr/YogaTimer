//
//  YogaTimerUITests.swift
//  YogaTimerUITests
//
//  Created by Sushrut Shringarputale on 7/10/17.
//  Copyright © 2017 Sushrut Shringarputale. All rights reserved.
//

import XCTest
import MaterialComponents.MaterialButtons

class YogaTimerUITests: XCTestCase {
    
    var app : XCUIApplication!
    
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // Configure the app
        app = XCUIApplication()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimer() {
        clickResetButton()
        XCTAssert(app.staticTexts["0"].exists)
        setMaxTime()
        
    }
    
    func clickResetButton() {
        app.buttons["Reset Button"].tap()
    }
    
    func setMaxTime() {
        app.collectionViews["Yoga Filler"].press(forDuration: 0.1, thenDragTo: app.buttons["Reset Button"])
    }
    
}
