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
var myMovieList = [Movie?]()

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieDetailView: UITextView!
    @IBOutlet weak var movieTitle: UILabel!
    
    var movie: Movie?
    var data: NSData?
    
    
    // MARK: - Core Data Convenience
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    
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
        
        // Add new movie to myMovieList array
        myMovieList.append(movie!)
        print(myMovieList.count)
        
        // Save to the coreData
        
    }

 
}
