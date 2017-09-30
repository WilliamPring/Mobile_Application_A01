//
//  Party.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-09-28.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import MapKit

class Party : NSObject, MKAnnotation {
    
    //MARK: Properties (Custom)
    var location: String
    var dateOfEvent: Date
    var amountOfPeople: Int
    
    //Conforming to the MKAnnotation protocol
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, location: String, dateOfEvent: Date, amountOfPeople: Int, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.location = location
        self.dateOfEvent = dateOfEvent
        self.amountOfPeople = amountOfPeople
        self.coordinate = coordinate
    }
    
    
    
}
