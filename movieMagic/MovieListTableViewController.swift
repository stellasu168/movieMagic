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
    
    let downloader = Downloader()
/*
    private let jsonURL: NSURL = {
        let apiKey = "qe43pmsb84evcmyj43gbe7j8"
        return NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=\(apiKey)")!
    }()
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Downloader.sharedInstance().beginDownloadingURL(Downloader.sharedInstance().jsonURL())
        self.tableView.reloadData()
        print ("viewDidLoad - \(moviesArray?.count)")


    }

    @IBAction func refresh(sender: AnyObject) {
        
        Downloader.sharedInstance().beginDownloadingURL(Downloader.sharedInstance().jsonURL())
        print ("refresh - \(moviesArray?.count)")
        self.tableView.reloadData()

        
    }

    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print ("numberOfRowsInSection - \(moviesArray?.count)")
        return moviesArray?.count ?? 0
        
    }
/*
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = cell as? MovieTableViewCell else { return }
        //guard let moviesArray = moviesArray else { return }
        
        let cellModel = moviesArray![indexPath.row]
        cell.model = cellModel
        
        if let existingData = Downloader.sharedInstance().dataForURL(cellModel.posterURL),
            let posterImage = UIImage(data: existingData) {
                cell.updateDisplayImages(posterImage)
                
        } else {
            
            print("tableview - else")
            let downloadedData = Downloader.sharedInstance().dataForURL(Downloader.sharedInstance().jsonURL())
            
            guard let image = UIImage(data: downloadedData!) else { return }

            
            Downloader.sharedInstance().beginDownloadingURL(cellModel.posterURL)
            
            for cell in tableView.visibleCells {
                
                guard let cell = cell as? MovieTableViewCell else { break }
                
                dispatch_async(dispatch_get_main_queue()) {
                    cell.updateDisplayImages(image)
                }

                
            }
            
    
        }
    }
    
*/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieTableViewCell
        
        let cellModel = moviesArray![indexPath.row]
        
        print(cellModel.title)
        cell.movieTitleLabel.text = cellModel.title
        
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


