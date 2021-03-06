//
//  MovieListTableViewController.swift
//  movieMagic
//
//  Created by Stella Su on 4/12/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

import UIKit

var moviesArray: [Movie]?

class MovieListTableViewController: UITableViewController {
    
    var data: NSData?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        Downloader.sharedInstance().beginDownloadingURL(Downloader.sharedInstance().jsonURL()) { success in
            if success{
                self.reloadTable()
            } else {
                print("Download movies failed")
            }
            
        }
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTable", name:"GotMovies", object: nil)

        
    }
    
    func reloadTable() -> Void {

        self.tableView.reloadData()
        // stop animating
        activityIndicator.stopAnimating()
    }


    @IBAction func refresh(sender: AnyObject) {
        
        moviesArray?.removeAll()
        self.tableView.reloadData()
        
        activityIndicator.startAnimating()
        
        Downloader.sharedInstance().beginDownloadingURL(Downloader.sharedInstance().jsonURL()) { success in
            if success {
                self.reloadTable()
            }
            
        }
        
    }

    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return moviesArray?.count ?? 0
        
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        UITableViewCell {
       
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieTableViewCell
        
        let cellModel = moviesArray![indexPath.row]
        
        cell.movieTitleLabel.text = cellModel.title
        cell.movieDescriptionLabel.text = cellModel.description
            
        let imageURL = NSURL(string: cellModel.posterURL.absoluteString)
        data = NSData(contentsOfURL:imageURL!)
        if data != nil {
            cell.moviePosterImageView.image = UIImage(data:data!)
        }
        
        return cell
        
    }
    
    // MARK: - Navigation

    // Preparation before navigation
    // Tableview is passing the cell. The cell is the sender.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "segueToDetails") {
    
            let movieDetailVC = segue.destinationViewController as! MovieDetailViewController
            // Passing the cell to MovieDetailViewController
            if let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell) {
            
                let cellModel = moviesArray![indexPath.row]
                movieDetailVC.movie = cellModel
                
            }
        }
    }
 
} // End of MovieListTableViewController class


