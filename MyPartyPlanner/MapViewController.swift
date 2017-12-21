//
//  MapViewController.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-09-26.
//  Copyright © 2017 Student. All rights reserved.
//

/*
 Filename: PartyTableViewController.swift
 By: Naween M, William P, Denys P
 Assignment: Assignment 2 Mobile iOS
 Date: December 2, 2017
 Description: The MapViewController will help display also a SegmentedControl inside the MapView for users 
 to switch which style they want to view the location pins. It also loads all the pins into the map from the
 TableView, the Party objects. Localization added. 
 */


import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: Properties
    lazy var allAnnotations: [MKAnnotation]? = nil

    var mapView : MKMapView!
    
    //MARK: Methods
    
    func mapTypeChange(_ segControl: UISegmentedControl) {
        var _ : Int = 0
        
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Load all the annotations on the map
        let tblController   = self.tabBarController?.viewControllers?[0] as! UINavigationController
        let pViewController = tblController.viewControllers[0] as! PartyTableViewController
        
        //First clear the map
        if allAnnotations != nil {
            self.mapView.removeAnnotations(allAnnotations!)
        }
        
        //Now add the new pins
        allAnnotations = pViewController.parties

        mapView.addAnnotations(allAnnotations!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        
        //Template based off Igor's sample code provided
        let standardString:String  = NSLocalizedString("Standard", comment: "Standard Map View")
        let satelliteString:String = NSLocalizedString("Satellite", comment: "Satellite Map View")
        let hybridString:String    = NSLocalizedString("Hybrid", comment: "Hybrid Map View")
        
        let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        //Add as a subview
        view.addSubview(segmentedControl)
        
        let margins = view.layoutMarginsGuide
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let leadingConstaint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstaint.isActive = true
        trailingConstraint.isActive = true
        
        segmentedControl.addTarget(self,
                                   action: #selector(MapViewController.mapTypeChange(_:)),
                                   for: .valueChanged)
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
