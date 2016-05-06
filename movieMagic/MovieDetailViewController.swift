//
//  MovieDetailViewController.swift
//  movieMagic
//
//  Created by Stella Su on 4/13/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

import UIKit
import CoreData

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
        
        // Check for duplicate
        if !movieExists((movie?.title)!) {
            
            _ = MyMovie(myMoviePoster: (movie?.posterURL.absoluteString)!, myMovieSynopsis: (movie?.description)!, myMovieTitle: (movie?.title)!, context: sharedContext)
            
            // Saving to context in core data
            CoreDataStackManager.sharedInstance().saveContext()
            
        } else {
            
            // Show an alert message

        }
        
    }
    
    func movieExists (movieToken:String) -> Bool {
        
        let request = NSFetchRequest(entityName: "MyMovie")
        
        // %@ means place the contents of a variable here, whatever data type it is
        let predicate = NSPredicate(format: "myMovieTitle == %@", movieToken)

        request.predicate = predicate
        
        print(predicate)
        
        do {
        
            let fetchResults = try sharedContext.executeFetchRequest(request)
            
            if fetchResults.count > 0 {
                print("already existed")
                print(fetchResults.count)
                return true
            }

        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        return false
        
    }

 
}




