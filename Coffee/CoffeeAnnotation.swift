//
//  CoffeeAnnotation.swift
//  Coffee
//
//  Created by Thinh Luong on 12/10/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import MapKit

/// Annotation for displaying Coffee venue.
class CoffeeAnnotation: NSObject, MKAnnotation {
  // MARK: Properties
  
  /// Title of Coffee venue.
  let title: String?
  
  /// Detail information of Coffee venue.
  let subtitle: String?
  
  /// Location coordinate of Coffee venue.
  let coordinate: CLLocationCoordinate2D
  
  // MARK: Lifecycle
  
  /**
  Initialize a CoffeeAnnotation.
  
  - Parameter title: Title of venue.
  - Parameter subtitle: Detail information of venue.
  - Parameter coordinate: Location coordinate of venue.
  
  */
  init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.subtitle = subtitle
    self.coordinate = coordinate
    
    super.init()
  }
}
