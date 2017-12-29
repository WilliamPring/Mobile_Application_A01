//
//  MKParty.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-12-22.
//  Copyright © 2017 Student. All rights reserved.
//

/*
 Filename: MKParty.swift
 By: Naween M, William P, Denys P
 Assignment: Assignment 3 Mobile iOS
 Date: December 2, 2017
 Description: This is for the annotation that will be drawn as pins in the MapView screen. 
 */

import MapKit
import Foundation

class MKParty: NSObject, MKAnnotation {
    var title: String?
    var info: String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, latitude: Double, longitude: Double, info: String) {
        self.title = title
        self.info  = info
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
    }
}
