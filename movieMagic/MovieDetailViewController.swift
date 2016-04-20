//
//  MovieDetailViewController.swift
//  movieMagic
//
//  Created by Stella Su on 4/13/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

import UIKit
import CoreData

// Global Var
var myMovieList = [MyMovie?]()

class MovieDetailViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieDetailView: UITextView!
    @IBOutlet weak var movieTitle: UILabel!
    
    var movie: Movie?
    var data: NSData?
    
    
    // MARK: - Core Data Convenience
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // Managed Object for My Movie
    lazy var managedObjectContext: NSManagedObjectContext = {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()

    
    // Lazily computed property pointing to the Photos entity objects, sorted by title, predicated on the pin.
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Create fetch request for photos which match the sent Pin.
        let fetchRequest = NSFetchRequest(entityName: "MyMovie")
        
        // Sort the fetch request by title, ascending.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // Create fetched results controller with the new fetch request.
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieDetailView.text = movie?.description // using optional chaining
        movieTitle.text = movie?.title
  
        let imageURL = NSURL(string: movie!.posterURL.absoluteString)
        data = NSData(contentsOfURL:imageURL!)
        if data != nil {
            moviePoster?.image = UIImage(data:data!)
        }
        
    }
    
    // Setting the UIImageView's image here, 
    // because I am sure that the ViewController's outlets have been set
    override func viewDidLayoutSubviews() {
        if data != nil {
            moviePoster.image = UIImage(data:data!)
        }
    }

    @IBAction func addToMyMovie(sender: AnyObject) {

        
        let newMovie = MyMovie(myMoviePoster: (movie?.posterURL.absoluteString)!, myMovieSynopsis: (movie?.description)!, myMovieTitle: (movie?.title)!, context: sharedContext)
        
        // Add new movie to myMovieList array
        myMovieList.append(newMovie)


        // Saving to context in core data
        CoreDataStackManager.sharedInstance().saveContext()
        print(myMovieList.count)
        
        
    }

 
}
