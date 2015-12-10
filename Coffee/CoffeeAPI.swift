//
//  CoffeeAPI.swift
//  Coffee
//
//  Created by Thinh Luong on 12/9/15.
//  Copyright © 2015 Thinh Luong. All rights reserved.
//

import QuadratTouch
import MapKit
import RealmSwift

/// API for interacting with external clients.
struct API {
  
  /// For use with NSNotificationCenter.
  struct Notifications {
    /// Key for successful update of venues from Foursquare.
    static let venuesUpdated = "venues updated"
  }
  
  /// Key for connecting to Foursquare developer API.
  struct FoursquareClient {
    static let id = "INJQJ10RYXC2R3ARAVUPJMU2V5NPU0G3WPFMXWP1QJL2HJU2"
    static let secret = "FACL3UCK0GC1PSKMZT32U5LYO2FDJ35VQPHQVFFDQXCD0KTO"
    static let url = ""
  }
}

/// Singleton for handling coffee venues.
class CoffeeAPI {
  
  // MARK: Functions
  /**
  Send a request for list of coffee venues at specified location. Upon success, data will be written to Realm and will post notification.
  
  - Parameter location: Location from which to search for surrounding coffee venues.
  
  */
  func getCoffeeShopsWithLocation(location: CLLocation) {
    if let session = session {
      var parameters = location.parameters()
      parameters += [Parameter.categoryId: "4bf58dd8d48988d1e0931735"]
      parameters += [Parameter.radius: "2000"]
      parameters += [Parameter.limit: "50"]
      
      let searchTask = session.venues.search(parameters) {
        result in
        
        if let response = result.response, let venues = response["venues"] as? [[String: AnyObject]] {
          autoreleasepool {
            
            let realm: Realm?
            
            do {
              try realm = Realm()
              print("Initialized Realm object.")
            } catch (let error){
              print("Failed to initialize Realm object: \(error)")
              realm = nil
            }
            
            if let realm = realm {
              realm.beginWrite()
              
              for venue in venues {
                let venueObject = Venue()
                if let id = venue["id"] as? String {
                  venueObject.id = id
                }
                
                if let name = venue["name"] as? String {
                  venueObject.name = name
                }
                
                if let coordinate = venue["location"] as? [String: AnyObject] {
                  if let longitude = coordinate["lng"] as? Float {
                    venueObject.longitude = longitude
                  }
                  
                  if let latitude = coordinate["lat"] as? Float {
                    venueObject.latitude = latitude
                  }
                  
                  if let address = coordinate["formattedAddress"] as? [String] {
                    venueObject.address = address.joinWithSeparator(" ")
                  }
                }
                
                realm.add(venueObject, update: true)
              }
              
              do {
                try realm.commitWrite()
                print("Realm committing write...")
              } catch (let error) {
                print("Error writing to Realm: \(error)")
              }
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(API.Notifications.venuesUpdated, object: nil, userInfo: nil)
          }
        }
      }
      
      searchTask.start()
    }
  }
  
  // MARK: Lifecycle
  /// Start session with Foursquare.
  init() {
    let client = Client(clientID: API.FoursquareClient.id, clientSecret: API.FoursquareClient.secret, redirectURL: API.FoursquareClient.url)
    
    let config = Configuration(client: client)
    Session.setupSharedSessionWithConfiguration(config)
    
    self.session = Session.sharedSession()
  }
  
  // MARK: Properties
  
  /// Singleton sharedInstance.
  static let sharedInstance = CoffeeAPI()
  
  /// Session object for connecting with Foursquare client.
  var session: Session?
}


// MARK: CLLocation Extension
extension CLLocation {
  /**
    Location request parameters for Foursquare.
   
   - Returns: lists of parameters.
   
   */
  func parameters() -> Parameters {
    let coordinate = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
    
    let parameters = [
      Parameter.ll: coordinate,
      Parameter.llAcc: self.horizontalAccuracy.description,
      Parameter.alt: self.altitude.description,
      Parameter.altAcc: self.verticalAccuracy.description
    ]
    
    return parameters
  }
}













































