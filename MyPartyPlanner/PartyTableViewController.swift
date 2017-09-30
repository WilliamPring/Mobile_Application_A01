//
//  PartyTableViewController.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-09-28.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import MapKit
import os.log

class PartyTableViewController: UITableViewController {
    
    //MARK: Properties
    var parties = [Party]()
    
    //MARK: Actions
    @IBAction func unwindToPartyList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? HomeViewController, let party = sourceViewController.party {
            let newIndexPath = IndexPath(row: parties.count, section: 0)
            parties.append(party)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    //MARK: Private Methods
    private func loadAllParties() {
        
        let randCoordinateLocation = CLLocationCoordinate2DMake(43.390297, -80.403226) //Points at Conestoga College
        
        //Create some sample data to preload for the user to see
        let testDate: Date = Date()
        let partyOne   = Party(title: "TEST_1", subtitle: "", location: "Kitchener", dateOfEvent: testDate, amountOfPeople: 10, coordinate: randCoordinateLocation)
        let partyTwo   = Party(title: "TEST_2", subtitle: "", location: "Vancouver", dateOfEvent: testDate, amountOfPeople: 10, coordinate: randCoordinateLocation)
        let partyThree = Party(title: "TEST_3", subtitle: "", location: "Toronto",   dateOfEvent: testDate, amountOfPeople: 10, coordinate: randCoordinateLocation)

        parties += [partyOne, partyTwo, partyThree] //Add party objects to the collection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem //Handles deletion of cells in that TableView
        
        loadAllParties()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return parties.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier: String = "PartyTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PartyTableViewCell
        let party = parties[indexPath.row]
        
        cell.nameLabel.text = party.title

        // Configure the cell...

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            parties.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "AddItem":
                os_log("Adding new party.", log: OSLog.default, type: .debug) //Does not require a change in scene
            
            case "ShowDetail":
                //Get the controller
                guard let pDetailViewController = segue.destination as? HomeViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                //Get the selected cell from the table views
                guard let selectedPartyCell = sender as? PartyTableViewCell else {
                        fatalError("Unexpected sender error")
                }
            
                //Get the correct index to look in the party list array 
                guard let indexPath = tableView.indexPath(for: selectedPartyCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
            
                //Grab the correct party now that the information has been obtained
                let theParty = parties[indexPath.row]
            
                //Show the selected party, property of the HomeViewController classs
                pDetailViewController.party = theParty
            
            default:
                fatalError("Unexpected Segue Identifier error")
        }
        
        
        
    }
 

}
