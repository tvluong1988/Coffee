//
//  ViewController.swift
//  Coffee
//
//  Created by Thinh Luong on 12/8/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: Functions
  
  /**
  Update venues from Foursquare if needed. Retrieve venue data from realm, sort it base on distance, update mapView, and update tableView.
  
  - Parameter location: Location of user.
  - Parameter getDataFromFoursquare: Request data from Foursquare.
  
  */
  func refreshVenues(location: CLLocation?, getDataFromFoursquare: Bool = false) {
    if let location = location {
      lastLocation = location
    }
    
    if let location = lastLocation {
      if getDataFromFoursquare {
        CoffeeAPI.sharedInstance.getCoffeeShopsWithLocation(location)
      }
      
      venues = venueManager.getVenues(location)
      
      for venue in venues! {
        let annotation = CoffeeAnnotation(id: venue.id, title: venue.name, subtitle: venue.address, coordinate: CLLocationCoordinate2D(latitude: Double(venue.latitude), longitude: Double(venue.longitude)))
        
        mapView?.addAnnotation(annotation)
      }
      
      tableView?.reloadData()
    }
  }
  
  /**
   Updates the CoffeeAnnotation on the mapView
  */
  func onVenuesUpdated() {
    refreshVenues(nil)
  }
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "onVenuesUpdated", name: API.Notifications.venuesUpdated, object: nil)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if locationManager == nil {
      locationManager = CLLocationManager()
      
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
      locationManager.requestAlwaysAuthorization()
      locationManager.distanceFilter = 50
      locationManager.startUpdatingLocation()
      
    }
  }
  
  // MARK: Properties
  var locationManager: CLLocationManager!
  var venueManager = VenueManager()
  var lastLocation: CLLocation?
  
  /// Array of venues.
  var venues: [Venue]?
  
  /// Distance span of mapView
  var distanceSpan: Double {
    return venueManager.distanceSpan
  }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return venues?.count ?? 0
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
    
    if let venue = venues?[indexPath.row] {
      cell.textLabel?.text = venue.name
      cell.detailTextLabel?.text = venue.address
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let venue = venues?[indexPath.row] {
      let region = MKCoordinateRegionMakeWithDistance(venue.coordinate2D, distanceSpan, distanceSpan)
      mapView?.setRegion(region, animated: true)
      
      if let annotations = mapView?.annotations {
        for annotation in annotations {
          if let annotation = annotation as? CoffeeAnnotation where annotation.id == venue.id {
            mapView?.selectAnnotation(annotation, animated: true)
            break
          }
        }
      }
    }
  }
}

// MARK: MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation.isKindOfClass(MKUserLocation) {
      return nil
    }
    
    let identifier = "annotationIdentifier"
    var view = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
    
    if view == nil {
      view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    }
    
    view?.canShowCallout = true
    
    return view
    
  }
}

// MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
  func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    if let mapView = mapView {
      let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, distanceSpan, distanceSpan)
      mapView.setRegion(region, animated: true)
      
      refreshVenues(newLocation, getDataFromFoursquare: true)
    }
  }
}









































