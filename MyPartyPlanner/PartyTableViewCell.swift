//
//  PartyTableViewCell.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-09-28.
//  Copyright © 2017 Student. All rights reserved.
//

/*
 Filename: PartyTableViewController.swift
 By: Naween M, William P, Denys P
 Assignment: Assignment 2 Mobile iOS
 Date: December 2, 2017
 Description: Custom cell that should be display in the TableView, it's only going to show the Party event name 
 */

import UIKit

class PartyTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
