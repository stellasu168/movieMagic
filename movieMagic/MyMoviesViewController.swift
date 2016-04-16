//
//  MyMoviesViewController.swift
//  movieMagic
//
//  Created by Stella Su on 4/15/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

import UIKit

class MyMoviesViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
        */
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
