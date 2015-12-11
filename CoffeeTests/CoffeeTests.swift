//
//  CoffeeTests.swift
//  CoffeeTests
//
//  Created by Thinh Luong on 12/8/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import XCTest
import MapKit
@testable import Coffee

class CoffeeTests: XCTestCase {
  
  // MARK: Tests
  func testCalculateCoordinatesWithRegion() {
    let distanceSpan: Double = 1000
    mockVenueManager.distanceSpan = distanceSpan
    
    let location = CLLocation(latitude: 0, longitude: 0)
    
    let (topLeft, bottomRight) = mockVenueManager.calculateCoordinatesWithRegion(location)

    XCTAssert(location.coordinate.latitude < topLeft.latitude)
    XCTAssert(location.coordinate.latitude > bottomRight.latitude)
    XCTAssert(location.coordinate.longitude > topLeft.longitude)
    XCTAssert(location.coordinate.longitude < bottomRight.longitude)
  }
  
  func testGetVenues() {
    viewController.venueManager = mockVenueManager
    
    XCTAssert(mockVenueManager.getVenuesWasCalled == false, "refreshVenueWasCalled should not be called before calling CoffeeAPI.")
    
    let location = CLLocation(latitude: 0, longitude: 0)
    viewController.refreshVenues(location)
    
    XCTAssert(mockVenueManager.getVenuesWasCalled == true, "refeshVenueWasCalled should be called.")
  }
  
  // MARK: Lifecycle
  override func setUp() {
    super.setUp()
  
    viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as! ViewController
  }
  
  override func tearDown() {
    super.tearDown()
  }
 
  // MARK: Properties
  var viewController: ViewController!
  var mockVenueManager = MockVenueManager()

  // MARK: Mock Classes
  class MockVenueManager: VenueManager {
    var getVenuesWasCalled = false
    
    override func getVenues(location: CLLocation) -> [Venue] {
      getVenuesWasCalled = true
      return [Venue]()
    }
  }
}
