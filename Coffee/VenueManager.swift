//
//  VenueManager.swift
//  Coffee
//
//  Created by Thinh Luong on 12/10/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import MapKit
import RealmSwift

/// VenueManager for the model.
class VenueManager {
  
  // MARK: Functions
  
  /**
  Retrieve an array of venues from Realm filtered by distance span of the specified location.
  
  - Parameter location: Central location for searching surrounding venues.
  
  - Returns: An array of venues.
  
  */
  func getVenues(location: CLLocation) -> [Venue] {
    let (topLeft, bottomRight) = calculateCoordinatesWithRegion(location)
    
    let predicate = NSPredicate(format: "latitude < %f AND latitude > %f AND longitude < %f AND longitude > %f", topLeft.latitude, bottomRight.latitude, bottomRight.longitude, topLeft.longitude)
    
    let realm = try! Realm()
    
    return realm.objects(Venue).filter(predicate).sort {
      location.distanceFromLocation($0.coordinate) < location.distanceFromLocation($1.coordinate)
    }

  }
  
  /**
  Calculate the region's top left and bottom right coordinate2D from a specified location.
  
  - Parameter location: Location center.
  
  - Returns: Tuple holding the top left and bottom right coordinate2D.
  
  */
  func calculateCoordinatesWithRegion(location: CLLocation) -> (CLLocationCoordinate2D, CLLocationCoordinate2D) {
    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, distanceSpan, distanceSpan)
    
    var topLeft = CLLocationCoordinate2D()
    var bottomRight = CLLocationCoordinate2D()
    
    topLeft.latitude = region.center.latitude + region.span.latitudeDelta * 0.5
    topLeft.longitude = region.center.longitude - region.span.longitudeDelta * 0.5
    bottomRight.latitude = region.center.latitude - region.span.latitudeDelta * 0.5
    bottomRight.longitude = region.center.longitude + region.span.longitudeDelta * 0.5
    
    return (topLeft, bottomRight)
  }
  
  // MARK: Properties
  
  /// Default distance span to display mapView.
  var distanceSpan: Double = 1000
}
