//
//  ViewController.swift
//  Coffee
//
//  Created by Thinh Luong on 12/8/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

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
      
      let (topLeft, bottomRight) = calculateCoordinatesWithRegion(location)
      
      let predicate = NSPredicate(format: "latitude < %f AND latitude > %f AND longitude < %f AND longitude > %f", topLeft.latitude, bottomRight.latitude, bottomRight.longitude, topLeft.longitude)
      
      let realm = try! Realm()
      
      venues = realm.objects(Venue).filter(predicate).sort {
        location.distanceFromLocation($0.coordinate) < location.distanceFromLocation($1.coordinate)
      }
      
      for venue in venues! {
        let annotation = CoffeeAnnotation(title: venue.name, subtitle: venue.address, coordinate: CLLocationCoordinate2D(latitude: Double(venue.latitude), longitude: Double(venue.longitude)))
        
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
  
  // MARK: Private Functions
  
  /**
  Calculate the region's top left and bottom right coordinate2D from a specified location.
  
  - Parameter location: Location center.
  
  - Returns: Tuple holding the top left and bottom right coordinate2D.
  
  */
  private func calculateCoordinatesWithRegion(location: CLLocation) -> (CLLocationCoordinate2D, CLLocationCoordinate2D) {
    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, distanceSpan, distanceSpan)
    
    var topLeft = CLLocationCoordinate2D()
    var bottomRight = CLLocationCoordinate2D()
    
    topLeft.latitude = region.center.latitude + region.span.latitudeDelta * 0.5
    topLeft.longitude = region.center.longitude - region.span.longitudeDelta * 0.5
    bottomRight.latitude = region.center.latitude - region.span.latitudeDelta * 0.5
    bottomRight.longitude = region.center.longitude + region.span.longitudeDelta * 0.5
    
    return (topLeft, bottomRight)
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
  
  /// Default distance span to display mapView.
  let distanceSpan: Double = 1000
  
  var lastLocation: CLLocation?
  
  /// Array of venues.
  var venues: [Venue]?
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









































