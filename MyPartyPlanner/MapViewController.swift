//
//  MapViewController.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-09-26.
//  Copyright © 2017 Student. All rights reserved.
//


import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var mapView : MKMapView! //Outlet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        
        //Template based off Igor's sample code provided
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
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
    
    func mapTypeChange(_ segControl: UISegmentedControl) {
    
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
