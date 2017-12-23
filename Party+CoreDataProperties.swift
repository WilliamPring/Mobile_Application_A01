//
//  Party+CoreDataProperties.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-12-21.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

extension Party {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Party> {
        return NSFetchRequest<Party>(entityName: "Party")
    }

    @NSManaged public var dateOfEvent: NSDate?
    @NSManaged public var isPartyCoverActive: Bool
    @NSManaged public var latitude:  Double
    @NSManaged public var longitude: Double
    @NSManaged public var numOfPeople: Int32
    @NSManaged public var title:    String?
    @NSManaged public var subtitle: String?
    @NSManaged public var details:  String?
    @NSManaged public var location: String?

}
