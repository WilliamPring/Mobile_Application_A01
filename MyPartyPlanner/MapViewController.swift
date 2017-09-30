//
//  MapViewController.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-09-26.
//  Copyright © 2017 Student. All rights reserved.
//


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
        
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let annotationTitle = view.annotation?.title {
            print("USER TAPPED: \(annotationTitle)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Load all the annotations on the map
        let tblController   = self.tabBarController?.viewControllers?[0] as! UINavigationController
        let pViewController = tblController.viewControllers[0] as! PartyTableViewController
        
        //First clear the map
        if allAnnotations != nil
        {
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
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    
}
