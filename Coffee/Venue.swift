//
//  Venue.swift
//  Coffee
//
//  Created by Thinh Luong on 12/9/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import RealmSwift
import MapKit

/// Represents a Coffee venue.
class Venue: Object {
  // MARK: Properties
  
  /// id number identifing the Coffee venue from Foursquare.
  dynamic var id: String = ""
  
  /// Name of the Coffee venue.
  dynamic var name: String = ""
  
  /// Latitude of Coffee venue.
  dynamic var latitude: Float = 0
  
  /// Longitude of Coffee venue.
  dynamic var longitude: Float = 0
  
  /// Address of Coffee venue.
  dynamic var address: String = ""
  
  /// CLLoation of Coffee venue.
  var coordinate: CLLocation {
    return CLLocation(latitude: Double(latitude), longitude: Double(longitude))
  }
  
  /// 2D coordinate of Coffee venue.
  var coordinate2D: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
  }
  
  // MARK: Functions
  
  /// Using "id" field as primary key in Realm.
  override static func primaryKey() -> String? {
    return "id"
  }
}

