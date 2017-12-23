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
    Assignment: Assignment 2 Mobile iOS
    Date: December 2, 2017
    Description: Responsible for maintaining the View (CreatePartyViewController) outlets and actions. This handles
    being able to create new Party objects to add to the TableView display. View also scales to different sized phones.
 
 */

import UIKit
import MapKit
import os.log
import CoreData

class HomeViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Properties
    var party: Party?
    
    lazy var context: NSManagedObjectContext = {
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return appDel.managedObjectContext
    }()

    let dateFormatter = DateFormatter()
    
    //Localized strings
    let canVancouver: String   = NSLocalizedString("Canada, Vancouver", comment: "")
    let canToronto:String      = NSLocalizedString("Canada, Toronto", comment: "")
    let usaNewYork:String      = NSLocalizedString("USA, New York", comment: "")
    let usaSeattle:String      = NSLocalizedString("USA, Seattle", comment: "")
    let usaSanFrancisco:String = NSLocalizedString("USA, San Francisco", comment: "")
    
    var locationOptions: [String] = []
    
    var selectedLocation: String = ""
    var currentRow = 0
    
    //Global field
    var mainField: AnyObject?
    var theInnerViewStack: AnyObject?
    
    @IBOutlet weak var memberCountTextLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var partyNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextView!
    @IBOutlet weak var stepperField: UIStepper!
    @IBOutlet weak var switchField: UISwitch!
    
    //Stack view related items
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var outerStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerTextViewStack: UIStackView!
    
    //Other Stack views (for the textfields)
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var locationStackView: UIStackView!
    
    var outerStackViewTopConstraintConstant: CGFloat = 10.0
    
    let theDatePicker = UIDatePicker()
    let theLocationPicker = UIPickerView()
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        memberCountTextLabel.text = Int(sender.value).description
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
        locationTextField.delegate  = self
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
        dateTextField.delegate  = self;
    }
    
    func SetLocationTextField() {
        
        locationTextField.text = locationOptions[currentRow]
        
        self.view.endEditing(true)
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.outerStackViewTopConstraint.constant = self.outerStackViewTopConstraintConstant
            self.view.layoutIfNeeded()
        })
    }
    
    
    func SetDateTextField() {
        //Format the date (Get rid of the timestamp when displaying the date value on the text field)
        let theDateFormatter = DateFormatter()
        theDateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateTextField.text = theDateFormatter.string(from: theDatePicker.date)
            
        self.view.endEditing(true)
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.outerStackViewTopConstraint.constant = self.outerStackViewTopConstraintConstant
            self.view.layoutIfNeeded()
        })
    }
    
    
    //
    //MARK: Override Functionss
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("Save button was not pressed, cancel everything", log: OSLog.default, type: .debug)
            return
        }
        
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
        
        let amountOfPeople: Int = Int(memberCountTextLabel.text!)!
        
        //Save information, create new NSManagedObject if necessary
        if party == nil {
            let entity = NSEntityDescription.entity(forEntityName: "Party", in:context)
            party = Party(entity: entity!, insertInto: context)
        }
        
        //Assign the new edits
        party?.title = name
        party?.subtitle = subtitle
        party?.location = location
        party?.dateOfEvent = randDate as NSDate
        party?.isPartyCoverActive = switchVal
        party?.numOfPeople = Int32(amountOfPeople)
        
        //
        //Make REST API call to Google Geocodings
        //GET the proper coordinates for the city chosen
        //
        getGeoCode(party: party!)
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let info = notification.userInfo {
            let rect: CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect //The keyboard dimensions
            
            //Find our target Y
            let targetY = view.frame.size.height - rect.height - 20 - (mainField?.frame.size.height)!
            
            //Find out where the stackview is relative to the frame
            let textViewY = outerStackView.frame.origin.y + (theInnerViewStack?.frame.origin.y)! + (mainField?.frame.origin.y)!
            
            let difference = targetY - textViewY
            
            let targetOffsetForTopConstraint = outerStackViewTopConstraint.constant + difference
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25, animations: {
                self.outerStackViewTopConstraint.constant = targetOffsetForTopConstraint
                self.view.layoutIfNeeded()
            })
        
        }
    }
    
    
    //Resign the first responder (keyboard) when done with the control
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        partyNameTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        subtitleTextField.resignFirstResponder()

        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.outerStackViewTopConstraint.constant = self.outerStackViewTopConstraintConstant
            self.view.layoutIfNeeded()
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Date related
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone   = TimeZone(abbreviation: "GMT+0:00")
        
        //Listen for the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        //Location Array - Add all available cities
        locationOptions += [canVancouver, canToronto, usaNewYork, usaSeattle, usaSanFrancisco]
        
        //Default value of members in a new party
        memberCountTextLabel.text = "0"
        
        //Date Picker
        CreateDatePicker()
        
        //Location Picker
        CreateLocationPicker()
        
        //Load contents of the Party Object if an existing one was selected from the TableViewController
        if let party = party {
            navigationItem.title      = party.title
            partyNameTextField.text   = party.title
            dateTextField.text        = dateFormatter.string(from: party.dateOfEvent! as Date)
            locationTextField.text    = party.location
            memberCountTextLabel.text = String(party.numOfPeople)
            subtitleTextField.text    = party.subtitle
            switchField.isOn          = party.isPartyCoverActive  //Switch
            stepperField.value        = Double(party.numOfPeople) //Stepper
        }
        
        //Text view border
        subtitleTextField.layer.cornerRadius = 5
        subtitleTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        subtitleTextField.layer.borderWidth = 0.5
        subtitleTextField.clipsToBounds = true
        
        //Keyboard for name and subtitle
        self.partyNameTextField.delegate = self
        self.subtitleTextField.delegate  = self
        
        //Prevent empty string from being assigned to name of party event
        updateSaveButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.outerStackViewTopConstraint.constant = self.outerStackViewTopConstraintConstant
            self.view.layoutIfNeeded()
        })
        
        return true
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            view.endEditing(true)
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.outerStackViewTopConstraint.constant = self.outerStackViewTopConstraintConstant
                self.view.layoutIfNeeded()
            })
            
            return false
        } else {
            return true
        }
    }
    
    
    //Determining how much the control should shift
    //so that the keyboard does not unintentionally block content
    func textViewDidBeginEditing(_ textView: UITextView) {
        mainField = textView
        theInnerViewStack = innerTextViewStack
    }
    
    //Depending on the control selected, this will determine how much the layout will shift
    //so that the keyboard does not unintentionally block content
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
        mainField = textField
        
        switch textField.tag
        {
            case 0:
                theInnerViewStack = nameStackView
            
            case 1:
                theInnerViewStack = dateStackView
            
            case 2:
                theInnerViewStack = locationStackView
            
            default:
                fatalError("Textfield tag was not recognized")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButton()
    }
    
    func updateSaveButton() {
        let textStr = partyNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        saveButton.isEnabled = !textStr.isEmpty
    }
    
    
    
    //
    //PICKER VIEW related methods
    //
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
    
    
    
    func getGeoCode(party: Party) {
        
        //var json: Any?
        let url = GeoCodeAPI.getGeoCodeGoogleURL(cityName: party.location!)
        let request = URLRequest(url: url)
        let task    = GeoCodeAPI.session.dataTask(with: request) { (data, response, error) -> Void in
            //Parse JSON response object 
            if party.location != "" {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any],
                        let results  = json["results"] as? [[String: Any]],
                        let geometry = results[0]["geometry"] as? [String: Any],
                        let location = geometry["location"]   as? [String: Any] {
                        
                        let longitude = location["lng"] as? Double
                        let latitude  = location["lat"] as? Double
                        
                        party.coordinate = CLLocationCoordinate2DMake(Double(latitude!), Double(longitude!))
                        
                    }
                    
                } catch {
                    print(error)
                }
            }
            
            //Now save the Core Data state
            do {
                try self.context.save()
            } catch {
                print("Error data not saved, \(error)")
            }
            
        }
        
        task.resume()
    }

    
    
}

