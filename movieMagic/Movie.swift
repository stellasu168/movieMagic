//
//  Movie.swift
//  movieMagic
//
//  Created by Stella Su on 4/12/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

import Foundation
import CoreData

struct Movie {

    let title: String
    let description: String
    let posterURL: NSURL
}

extension Movie {
    init(managedTask: NSManagedObject) {
        self.title = managedTask.valueForKey("title") as! String
        self.description = managedTask.valueForKey("synopsis") as! String
        self.posterURL = managedTask.valueForKey("poster") as! NSURL
    }
}


extension Movie {
    static func moviesFromDictionaryArray(dictionaryArray: [NSDictionary]) -> [Movie]? {
        var movieArray = [Movie]()
        
        for dictionary in dictionaryArray {
            if let posterDictionary = dictionary["posters"] as? NSDictionary,
                let posterURLString = posterDictionary["thumbnail"] as? String,
                let posterURL = NSURL(string: posterURLString) {
                    
                    let movieTitle = dictionary["title"] as? String ?? "Title Not Found"
                    let movieDescription = dictionary["synopsis"] as? String ?? "Synopsys Not Found"
                    
                    movieArray += [Movie(title: movieTitle, description: movieDescription, posterURL: posterURL)]
            }
        }
        
        if movieArray.isEmpty == false {
            return movieArray
        } else {
            return .None
        }
    }
}

