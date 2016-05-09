//
//  MovieListTableViewController.swift
//  movieMagic
//
//  Created by Stella Su on 4/12/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    
    private var moviesArray: [Movie]?
    private let downloader = Downloader()
    private let jsonURL: NSURL = {
        let apiKey = "qe43pmsb84evcmyj43gbe7j8"
        return NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=\(apiKey)")!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.downloader.delegate = self
        self.downloader.beginDownloadingURL(self.jsonURL)

    }

    @IBAction func refresh(sender: AnyObject) {
        
        downloadFinishedForURL(jsonURL)
        
    }

    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesArray?.count ?? 0
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? MovieTableViewCell else { return }
        guard let moviesArray = self.moviesArray else { return }
        
        let cellModel = moviesArray[indexPath.row]
        cell.model = cellModel
        
        if let existingData = self.downloader.dataForURL(cellModel.posterURL),
            let posterImage = UIImage(data: existingData) {
                cell.updateDisplayImages(posterImage)
                
        } else {
            self.downloader.beginDownloadingURL(cellModel.posterURL)
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        // Configure the cell...
        let optionalCell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as? MovieTableViewCell
        guard let cell = optionalCell else { fatalError() }
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


extension MovieListTableViewController: DownloaderDelegate {
    func downloadFinishedForURL(finishedURL: NSURL) {
        guard let downloadedData = self.downloader.dataForURL(finishedURL) else { return }
        
        if finishedURL == self.jsonURL {
            let json = try? NSJSONSerialization.JSONObjectWithData(downloadedData, options: .AllowFragments)
            if let jsonDictionary = json as? NSDictionary,
                let dictionaryArray = jsonDictionary["movies"] as? [NSDictionary] {
                    let movieArray = Movie.moviesFromDictionaryArray(dictionaryArray)
                    dispatch_async(dispatch_get_main_queue()) {
                        // Grab the main queue because NSURLSession can callback on any
                        // queue and we're touching non-atomic properties and the UI
                        self.moviesArray = movieArray
                        self.tableView.reloadData()
                    }
            }
        } else {
            guard let image = UIImage(data: downloadedData) else { return }
            for cell in self.tableView.visibleCells {
                guard let cell = cell as? MovieTableViewCell else { break }
                if cell.model?.posterURL == finishedURL {
                    // Grab the main queue because NSURLSession can callback on any
                    // queue and we're touching non-atomic properties and the UI
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.updateDisplayImages(image)
                    }
                    break
                }
            }
        }
    }
}
