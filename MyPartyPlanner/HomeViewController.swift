//
//  ViewController.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-09-25.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import os.log

class HomeViewController: UIViewController, UINavigationControllerDelegate {

    //MARK: Properties
    
    var party: Party?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //MARK: Navigation
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("Save button was not pressed, cancel everything", log: OSLog.default, type: .debug)
            return
        }
        
        let name: String = "anotherTest"
        let location: String = "New York"
        let randDate: Date = Date()
        let amountOfPeople: Int = 100
        
        party = Party(eventName: name, location: location, dateOfEvent: randDate, amountOfPeople: amountOfPeople)
    }
    
    
    
    
    
    @IBAction func nextCreatePartyViewButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreatePartyViewSegue", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func PartyDetailViewButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PartyDetailViewSegue", sender: self)
    }

}

