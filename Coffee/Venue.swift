//
//  Venue.swift
//  Coffee
//
//  Created by Thinh Luong on 12/9/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import RealmSwift
import MapKit

class Venue: Object {
  dynamic var id: String = ""
  dynamic var name: String = ""
  dynamic var latitude: Float = 0
  dynamic var longitude: Float = 0
  dynamic var address: String = ""
  
  var coordinate: CLLocation {
    return CLLocation(latitude: Double(latitude), longitude: Double(longitude))
  }
  
  var coordinate2D: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}

