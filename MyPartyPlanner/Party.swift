//
//  Party.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-09-28.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class Party {
    
    //MARK: Properties 
    
    var eventName: String
    var location: String
    var dateOfEvent: Date
    var amountOfPeople: Int
    
    
    init(eventName: String, location: String, dateOfEvent: Date, amountOfPeople: Int) {
        self.eventName = eventName
        self.location = location
        self.dateOfEvent = dateOfEvent
        self.amountOfPeople = amountOfPeople
    }
    
    
    
}
