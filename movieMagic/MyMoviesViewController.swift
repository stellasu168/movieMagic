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
    
    var data: NSData?
    
    // MARK: - Core Data Convenience
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // Mark: - Fetched Results Controller
    
    // Lazily computed property pointing to the MyMovie entity objects, sorted by title.
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Create fetch request for photos which match the sent Pin.
        let fetchRequest = NSFetchRequest(entityName: "MyMovie")
        
        // Sort the fetch request by title, ascending.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "myMovieTitle", ascending: true)]
        
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
 
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("\(error)")
        }

        
    }
 

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let sectionInfo = self.fetchedResultsController.sections![section]
        
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //TODO: Implement method to return cell with the correct reuseidentifier and populated with the correct data.
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myMovieCell") as! MyMovieTableViewCell

        let currentMovie = fetchedResultsController.objectAtIndexPath(indexPath) as! MyMovie
        
        
        cell.myMovieTitle.text = currentMovie.myMovieTitle
        cell.myMovieSynopsis.text = currentMovie.myMovieSynopsis
        
        let imageURL = NSURL(string: currentMovie.myMoviePoster)
        data = NSData(contentsOfURL:imageURL!)
        if data != nil {
            cell.myMoviePoster.image = UIImage(data:data!)
        }
        
        return cell
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
