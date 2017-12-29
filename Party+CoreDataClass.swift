//
//  Party+CoreDataClass.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-12-21.
//  Copyright © 2017 Student. All rights reserved.
//

/*
 Filename: Party+CoreDataClass.swift
 By: Naween M, William P, Denys P
 Assignment: Assignment 3 Mobile iOS
 Date: December 2, 2017
 Description: File for ensuring persistent data storage. Contains the class definition and methods.
 */

import Foundation
import CoreData
import CoreLocation

@objc(Party)
public class Party: NSManagedObject {
    var coordinate: CLLocationCoordinate2D? = nil
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        
        //Custom properties
        title = ""
        subtitle = ""
        location = ""
        details  = ""
        dateOfEvent = NSDate()
        numOfPeople = 0
        latitude  = 0.0
        longitude = 0.0
        isPartyCoverActive = false
        
        //Points at Conestoga College (Default)
        coordinate = CLLocationCoordinate2DMake(43.390297, -80.403226)
    }
    
    //Join the latitude and longitude
    public func setCoordinate(lat:Double, lng:Double) -> Void {
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: lng)
    }
    
}
