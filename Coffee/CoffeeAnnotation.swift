//
//  CoffeeAnnotation.swift
//  Coffee
//
//  Created by Thinh Luong on 12/10/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import MapKit

class CoffeeAnnotation: NSObject, MKAnnotation {
  let title: String?
  let subtitle: String?
  let coordinate: CLLocationCoordinate2D
  
  init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.subtitle = subtitle
    self.coordinate = coordinate
    
    super.init()
  }
}
