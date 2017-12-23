//
//  Party+CoreDataClass.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-12-21.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

@objc(Party)
public class Party: NSManagedObject {
    var coordinate: CLLocationCoordinate2D? = nil
    
    /*
    init(title:String, subtitle:String, location:String, details:String, dateOfEvent:NSDate,
         numOfPeople:Int32, latitude:Double, longitude:Double, isPartyCoverActive:Bool) {
        
        self.title = title
        self.subtitle = subtitle
        self.location = location
        self.details  = details
        self.dateOfEvent = dateOfEvent
        self.numOfPeople = numOfPeople
        self.latitude   = latitude
        self.longitude  = longitude
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    } */
    
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
