//
//  MyMoviesViewController.swift
//  movieMagic
//
//  Created by Stella Su on 4/15/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

import UIKit
import CoreData

class MyMoviesViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Core Data Convenience
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // Mark: - Fetched Results Controller
    
    // Lazily computed property pointing to the Photos entity objects, sorted by title, predicated on the pin.
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Create fetch request for photos which match the sent Pin.
        let fetchRequest = NSFetchRequest(entityName: "Movie")
        
        
        // Sort the fetch request by title, ascending.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // Create fetched results controller with the new fetch request.
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform the fetch
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("\(error)")
        }
        
        // Set the delegate to this view controller
        fetchedResultsController.delegate = self

  
    }
 
    @IBAction func settings(sender: AnyObject) {
        
        for item in myMovieList{
            print(item)
        }

    }

    @IBAction func refresh(sender: AnyObject) {
        
        self.tableView.reloadData()
    
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("myMovieList.count = \(myMovieList.count)")
        return myMovieList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //TODO: Implement method to return cell with the correct reuseidentifier and populated with the correct data.
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myMovieCell") as! MyMovieTableViewCell
        let currentMovie = myMovieList[indexPath.row]
        
        cell.myMovieTitle.text = currentMovie?.title
        
        return cell
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
