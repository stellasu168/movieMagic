//
//  Downloader.swift
//  movieMagic
//
//  Created by Stella Su on 4/12/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

// MARK: - This file is for download helper

import Foundation
import UIKit

protocol DownloaderDelegate: class {
    func downloadFinishedForURL(finishedURL: NSURL)
}

class Downloader: NSObject {
    
    weak var delegate: DownloaderDelegate?
    
    private let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    private var downloaded = [NSURL : NSData]()
    
    func jsonURL() -> NSURL{
        let apiKey = "qe43pmsb84evcmyj43gbe7j8"
        return NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=\(apiKey)")!
    }
    
    func beginDownloadingURL(downloadURL: NSURL, completionHandler: (success: Bool) -> Void) {
        
        self.session.dataTaskWithRequest(NSURLRequest(URL: downloadURL)) { (downloadedData, response, error) in
            
            guard let downloadedData = downloadedData else {
                NSLog("Downloader: Downloaded Data was NIL for URL: \(downloadURL)")
                print("\(error!.localizedDescription)")

                dispatch_async(dispatch_get_main_queue(), {
                  
                    let alert = UIAlertView()
                    alert.title = "Alert"
                    alert.message = "\(error!.localizedDescription)"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    
                })

                return
            }

            guard let response = response as? NSHTTPURLResponse else {
                NSLog("Downloader: Response was not an HTTP Response for URL: \(downloadURL)")
                print("Response was not an HTTP Response for URL")
                return
            }
            
            switch response.statusCode {
            case 200:
                self.downloaded[downloadURL] = downloadedData
                self.downloadFinishedForURL(downloadURL, completionHandler: completionHandler)
            default:
                NSLog("Downloader: Received Response Code: \(response.statusCode) for URL: \(downloadURL)")
            }
            }.resume()
    }
    
    func dataForURL(requestURL: NSURL) -> NSData? {
        return self.downloaded[requestURL]
    }
    
    func downloadFinishedForURL(finishedURL: NSURL, completionHandler: (success: Bool) -> Void) {
        
        guard let downloadedData = dataForURL(finishedURL) else { print("Can't download data"); return }
        
        if finishedURL == jsonURL() {
            let json = try? NSJSONSerialization.JSONObjectWithData(downloadedData, options: .AllowFragments)
            
            if let jsonDictionary = json as? NSDictionary,
                let dictionaryArray = jsonDictionary["movies"] as? [NSDictionary]
                
            {
                if let movieArray = Movie.moviesFromDictionaryArray(dictionaryArray)
                {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        // Grab the main queue because NSURLSession can callback on any
                        // queue and we're touching non-atomic properties and the UI
                        moviesArray = movieArray
                        completionHandler(success: true)
                        //NSNotificationCenter.defaultCenter().postNotificationName("GotMovies", object: nil)

                    }
                    
                    
                }
                
            }
            
        }
    }
    
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> Downloader {
        
        struct Singleton {
            static var sharedInstance = Downloader()
        }
        
        return Singleton.sharedInstance
    }

    
}



