//
//  ViewController.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-09-25.
//  Copyright © 2017 Student. All rights reserved.
//

/*
    Filename: HomeViewController.swift
    By: Naween M, William P, Denys P
    Assignment: Assignment 1 Mobile iOS
    Date: October 2, 2017
    Description: Responsible for maintaining the View (CreatePartyViewController) outlets and actions. This handles
    being able to create new Party objects to add to the TableView display. View also scales to different sized phones.
 
 */

import UIKit
import MapKit
import os.log

class HomeViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Properties
    
    var party: Party?
    var locationOptions = ["Canada, Vancouver", "Canada, Toronto", "USA, New York", "USA, Seattle", "USA, San Francisco"]
    
    var selectedLocation: String = ""
    var currentRow = 0
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var partyNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var subtitleTextField: UITextView!
    @IBOutlet weak var stepperField: UIStepper!
    @IBOutlet weak var switchField: UISwitch!
    
    let theDatePicker = UIDatePicker()
    let theLocationPicker = UIPickerView()
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        memberCountLabel.text = Int(sender.value).description
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //Controller is dismissed in two different ways due to style of presentation (modal or push)
        //Show if detail scene was presenting by user tapping on the party item
        self.navigationController?.popViewController(animated: true) //Pop off the Navigation stack
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextCreatePartyViewButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreatePartyViewSegue", sender: self)
    }
    
    @IBAction func PartyDetailViewButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PartyDetailViewSegue", sender: self)
    }
    
    
    
    func CreateLocationPicker() {
        //The toolbar
        let toolbar = UIToolbar()
        
        //Fit the screen size
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(SetLocationTextField))
        
        //Add created button to the toolbar
        toolbar.setItems([doneButton], animated: false)
        
        //Assign to the original date picker (which is actually a text field on the View)
        theLocationPicker.dataSource = self
        theLocationPicker.delegate   = self
        
        self.pickerView(self.theLocationPicker, didSelectRow: 0, inComponent: 0)
        
        locationTextField.inputAccessoryView = toolbar
        locationTextField.inputView = theLocationPicker
    }
    
    
    //MARK: UI Related Methods 
    func CreateDatePicker() {
        
        //Before proceeding, only show date as the format
        theDatePicker.datePickerMode = .date
        
        //The toolbar
        let toolbar = UIToolbar()
        
        //Fit the screen size
        toolbar.sizeToFit()
        
        //Assign the button now
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(SetDateTextField))
        
        //Add created button to the toolbar 
        toolbar.setItems([doneButton], animated: false)
        
        //Assign to the original date picker (which is actually a text field on the View)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = theDatePicker
    }
    
    func SetLocationTextField() {
        
        locationTextField.text = locationOptions[currentRow]
        
        self.view.endEditing(true)
    }
    
    func SetDateTextField() {
        //Format the date (Get rid of the timestamp when displaying the date value on the text field)
        let theDateFormatter = DateFormatter()
        theDateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateTextField.text = theDateFormatter.string(from: theDatePicker.date)
            
        self.view.endEditing(true)
    }
    
    
    //MARK: Override Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("Save button was not pressed, cancel everything", log: OSLog.default, type: .debug)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        let name: String = partyNameTextField.text!
        let subtitle: String = subtitleTextField.text
        let location: String = locationTextField.text!
        
        //Date field
        var randDate: Date
        
        if (dateTextField.text! == "") {
            randDate = Date()
        } else {
            randDate = dateFormatter.date(from: dateTextField.text!)!
        }
        
        //Swith field
        var switchVal: Bool
        
        if(switchField.isOn == true) {
            switchVal = true
        } else {
            switchVal = false
        }
        
        let amountOfPeople: Int = Int(memberCountLabel.text!)!
        let randCoordinateLocation = CLLocationCoordinate2DMake(43.390297, -80.403226) //Points at Conestoga College

        party = Party(title: name, subtitle: subtitle, location: location, dateOfEvent: randDate, amountOfPeople: amountOfPeople, coordinate: randCoordinateLocation, isPartyCoverActive: switchVal)
        party?.location = location
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Date Picker
        CreateDatePicker()
        
        //Location Picker
        CreateLocationPicker()
        
        if let party = party {
            let theDateFormatter = DateFormatter()
            theDateFormatter.dateFormat = "yyyy-MM-dd"
            
            partyNameTextField.text = party.title
            dateTextField.text = theDateFormatter.string(from: party.dateOfEvent)
            locationTextField.text  = party.location
            memberCountLabel.text   = String(party.amountOfPeople)
            subtitleTextField.text  = party.subtitle
            switchField.isOn = party.isPartyCoverActive
            
            //Stepper value
            stepperField.value = Double(party.amountOfPeople)
        }
        
        //Text view border
        subtitleTextField.layer.cornerRadius = 5
        subtitleTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        subtitleTextField.layer.borderWidth = 0.5
        subtitleTextField.clipsToBounds = true
        
        //Keyboard for name and subtitle
        self.partyNameTextField.delegate = self
        self.subtitleTextField.delegate  = self
        
        //Prevent empty string beign assigned to name of party event
        updateSaveButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            view.endEditing(true)
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButton()
    }
    
    func updateSaveButton() {
        let textStr = partyNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        saveButton.isEnabled = !textStr.isEmpty
    }
    
    //PICKER VIEW related methods
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int ) -> String? {
        return locationOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentRow = row
        selectedLocation = locationOptions[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

}

