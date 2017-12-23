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
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: Properties
    lazy var allAnnotations: [MKAnnotation]? = nil
    
    lazy var context: NSManagedObjectContext = {
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return appDel.managedObjectContext
    }()

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
        
        let partyFetch = NSFetchRequest<Party>(entityName: "Party")
        var isAddAnnotations:Bool = false
        var theAcceptedAnnotation:[MKAnnotation] = []
        
        do {
            //Remove all annotations
            if allAnnotations != nil {
                self.mapView.removeAnnotations(allAnnotations!)
            }
            
            let theParties:[Party] = try context.fetch(partyFetch)
            
            for party in theParties {
                if party.latitude != 0 && party.longitude != 0 {
                    let pin:MKParty = MKParty(title: party.title!,
                                              latitude:  party.latitude,
                                              longitude: party.longitude,
                                              info: party.subtitle!)
                    theAcceptedAnnotation.append(pin)
                    
                    
                    /*
                    let annView:MKAnnotationView = MKPinAnnotationView(annotation: pin, reuseIdentifier: "Party")
                    annView.canShowCallout = true
                    
                    let btn = UIButton(type: .detailDisclosure)
                    annView.rightCalloutAccessoryView = btn */
                    
                    isAddAnnotations = true
                }
            }
            
            if isAddAnnotations == true {
                allAnnotations = theAcceptedAnnotation
                mapView.addAnnotations(allAnnotations!)
            }
            
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadView()
    }
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        mapView.delegate = self
        
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
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Party"
        
        if annotation is MKParty {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                //Add detail button
                let btn = UIButton(type: .detailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
                
                //Change tint colour
                (annotationView as! MKPinAnnotationView).pinTintColor = UIColor.brown
                
                //Set image
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                          width: annotationView!.frame.height,
                                                          height: annotationView!.frame.height))
                
                imageView.image = UIImage(named: "party_icon")
                imageView.contentMode = .scaleAspectFit
                
                annotationView!.leftCalloutAccessoryView = imageView
            } else {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        
        //This might mean apple's default pin is being displayed
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let party:MKParty = view.annotation as! MKParty
        let placeName = party.title
        let placeInfo = party.info
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
}
