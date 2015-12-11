//
//  CoffeeUITests.swift
//  CoffeeUITests
//
//  Created by Thinh Luong on 12/8/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import XCTest

class CoffeeUITests: XCTestCase {
  
  // MARK: Tests
  func testTableViewTap() {
    app.tables.element.staticTexts["Starbucks"].tap()
    
    // Current Xcode failed to identify map element.
    XCTAssert(app.maps.element.staticTexts["Starbucks"].exists)
  }
  
  // MARK: Lifecycle
  override func setUp() {
    super.setUp()
    
    continueAfterFailure = false
    XCUIApplication().launch()
    
    print(app.debugDescription)
    
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: Properties
  let app = XCUIApplication()
}
