//
//  Party.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-09-28.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Party : NSObject, MKAnnotation {
    
    //MARK: Properties (Custom)
    var dateOfEvent: Date
    var amountOfPeople: Int
    
    lazy var geocoder = CLGeocoder()
    
    var location: String {
    
        willSet{
            //Forward Geocoding 
            
             geocoder.geocodeAddressString(newValue) { (placemarks, error) in
                var newLocation: CLLocation?
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    newLocation = placemarks.first?.location
                }
                
                if let newLocation = newLocation {
                    let newCoordinate = newLocation.coordinate
                    self.coordinate = newCoordinate
                }
            }
        }
    
    }
    
    
    //Conforming to the MKAnnotation protocol
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, location: String, dateOfEvent: Date, amountOfPeople: Int, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.location = location
        self.dateOfEvent = dateOfEvent
        self.amountOfPeople = amountOfPeople
        self.coordinate = coordinate
    }
    
    
    
}
