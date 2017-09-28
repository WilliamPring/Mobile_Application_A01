//
//  PartyTableViewController.swift
//  MyPartyPlanner
//
//  Created by Student on 2017-09-28.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

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
        
        let testDate: Date = Date()
        let partyOne = Party(eventName: "TEST_1", location: "San Fran", dateOfEvent: testDate, amountOfPeople: 10)
        let partyTwo = Party(eventName: "TEST_2", location: "San Fran", dateOfEvent: testDate, amountOfPeople: 10)
        let partyThree = Party(eventName: "TEST_3", location: "San Fran", dateOfEvent: testDate, amountOfPeople: 10)

        parties += [partyOne, partyTwo, partyThree]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        
        cell.nameLabel.text = party.eventName

        // Configure the cell...

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
