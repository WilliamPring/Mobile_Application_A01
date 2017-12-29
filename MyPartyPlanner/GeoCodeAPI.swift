//
//  GeoCodeAPI.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-12-19.
//  Copyright © 2017 Student. All rights reserved.
//

/*
 Filename: GeoCodeAPI.swift
 By: Naween M, William P, Denys P
 Assignment: Assignment 3 Mobile iOS
 Date: December 2, 2017
 Description: This is for the RESTful API call to Google's Geocoding services so that 
 the program can retrieve the geographical coordinates of a particular location
 */


import Foundation

struct GeoCodeAPI {
    private static let baseURLString = "https://maps.googleapis.com/maps/api/geocode/json?"
    private static let APIKey = "AIzaSyD6TQPhIv8s9YNnFTnBkyIjJQT9t0yF9DQ"
    
    static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    static func getGeoCodeGoogleURL(cityName: String) -> URL {
        
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "address": cityName,
            "key": APIKey,
        ]
        
        
        for (key, value) in baseParams {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
}
