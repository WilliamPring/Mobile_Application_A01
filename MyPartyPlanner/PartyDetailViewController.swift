//
//  PartyDetailViewController.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-09-26.
//  Copyright © 2017 Student. All rights reserved.
//


import UIKit

class PartyDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

