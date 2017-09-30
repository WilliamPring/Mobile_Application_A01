//
//  ViewController.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-09-25.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import MapKit
import os.log

class HomeViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Properties
    
    var party: Party?
    var locationOptions = ["Canada, Vancouver", "Canada, Toronto", "USA, New York", "USA, Seattle", "USA, San Francisco"]
    var selectedLocation: String = ""
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var partyNameTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //MARK: Navigation
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        //Controller is dismissed in two different ways due to style of presentation (modal or push)
        //Show if detail scene was presenting by user tapping on the party item
        self.navigationController?.popViewController(animated: true) //Pop off the Navigation stack
        dismiss(animated: true, completion: nil)
    }
   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("Save button was not pressed, cancel everything", log: OSLog.default, type: .debug)
            return
        }
        
        let name: String = partyNameTextField.text!
        let location: String = selectedLocation
        let randDate: Date = Date()
        let amountOfPeople: Int = 100
        let randCoordinateLocation = CLLocationCoordinate2DMake(43.390297, -80.403226) //Points at Conestoga College

        party = Party(title: name, subtitle: "", location: location, dateOfEvent: randDate, amountOfPeople: amountOfPeople, coordinate: randCoordinateLocation)
        party?.location = location
    }
    
    
    @IBAction func nextCreatePartyViewButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreatePartyViewSegue", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        partyNameTextField.delegate = self
        
        if let party = party {
            partyNameTextField.text = party.title
        }
        
        pickerView.dataSource = self
        pickerView.delegate = self
        self.pickerView(self.pickerView, didSelectRow: 0, inComponent: 0)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func PartyDetailViewButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PartyDetailViewSegue", sender: self)
    }
    
    
    //PICKER VIEW related methods
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int ) -> String? {
        return locationOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLocation = locationOptions[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

}

