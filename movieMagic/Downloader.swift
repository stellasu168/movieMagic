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

class Downloader {
    
    weak var delegate: DownloaderDelegate?
    
    private let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    private var downloaded = [NSURL : NSData]()
    
    func beginDownloadingURL(downloadURL: NSURL) {
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
                return
            }
            
            switch response.statusCode {
            case 200:
                self.downloaded[downloadURL] = downloadedData
                self.delegate?.downloadFinishedForURL(downloadURL)
            default:
                NSLog("Downloader: Received Response Code: \(response.statusCode) for URL: \(downloadURL)")
            }
            }.resume()
    }
    
    func dataForURL(requestURL: NSURL) -> NSData? {
        return self.downloaded[requestURL]
    }
}



