//
//  Party.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-09-28.
//  Copyright © 2017 Student. All rights reserved.
//

/*
 Filename: PartyTableViewController.swift
 By: Naween M, William P, Denys P
 Assignment: Assignment 1 Mobile iOS
 Date: October 2, 2017
 Description: Details about the Party class that will show where the party is happening, number of attendees, name, description and etc. These
 will be displayed in a formatted fashion using a TableView
 */

import UIKit
import MapKit
import CoreLocation

class Party : NSObject, MKAnnotation {
    
    //MARK: Properties (Custom)
    
    lazy var geocoder = CLGeocoder()

    var dateOfEvent: Date
    var amountOfPeople: Int
    var isPartyCoverActive: Bool
    
    //Conforming to the MKAnnotation protocol
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
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
    
    init(title: String, subtitle: String, location: String, dateOfEvent: Date, amountOfPeople: Int, coordinate: CLLocationCoordinate2D, isPartyCoverActive: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.location = location
        self.dateOfEvent = dateOfEvent
        self.amountOfPeople = amountOfPeople
        self.coordinate = coordinate
        self.isPartyCoverActive = isPartyCoverActive
    }
    
    
    
}
