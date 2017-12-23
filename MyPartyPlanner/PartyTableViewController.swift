//
//  PartyTableViewController.swift
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
 Description: Responsible for handling the TableView, inserting new Party objects and deleting existing Party objects.
 */

import UIKit
import MapKit
import os.log
import CoreData

class PartyTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    //
    //MARK: Properties
    //
    var fetchedResultsController: NSFetchedResultsController<Party>!
    @IBOutlet weak var partyTableView: UITableView!
    
    //Mark: - Properties
    lazy var context: NSManagedObjectContext = {
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return appDel.managedObjectContext
    }()
    
    func fetchAllPartyObjects() {
        let fetchRequest = NSFetchRequest<Party>(entityName: "Party")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to perform fetch: \(error)")
        }
    }
    
    
    
    //
    //MARK: Actions
    //
    @IBAction func unwindToPartyList(sender: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Handles deletion of cells in that TableView (left barbutton)
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        fetchAllPartyObjects()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Get all party objects 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //
    // MARK: - Table view data source (Mandatory)
    //
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        guard let parties = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return parties.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Called for each cell separately
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartyTableViewCell", for: indexPath)
        
        // Set up the cell
        let party = self.fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = party.title
        cell.detailTextLabel?.text = party.subtitle
        
        //Populate the cell from the object
        return cell
    }
 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // Return false if you do not want the specified item to be editable.
    }
 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Delete the row from the data source
        if editingStyle == .delete {
            //Get Object
            let sParty: Party = fetchedResultsController.object(at: indexPath)
            
            //Delete object and save core data state
            do {
                self.context.delete(sParty)
                try self.context.save()
            } catch {
                print("Error data not saved, \(error)")
            }
        }
    }
    
    
    //
    //NSFetchedResultsControllerDelegate --> Protocol with all the required methods to identify changes in TableView
    //
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        partyTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                partyTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                partyTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            case .move:
                break
            case .update:
                break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                partyTableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                partyTableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                partyTableView.reloadRows(at: [indexPath!], with: .fade)
            case .move:
                partyTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        partyTableView.endUpdates()
    }
    
    
    

    
    
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
                let oParty: Party = fetchedResultsController.object(at: indexPath)

                //Show the selected party, property of the HomeViewController class
                pDetailViewController.party = oParty
            
            default:
                fatalError("Unexpected Segue Identifier error")
        }
    }
 

}
