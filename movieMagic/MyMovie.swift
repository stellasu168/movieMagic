//
//  MyMovie.swift
//  movieMagic
//
//  Created by Stella Su on 4/20/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

import UIKit
import CoreData

class MyMovie: NSManagedObject {
    
    @NSManaged var myMoviePoster: String
    @NSManaged var myMovieSynopsis: String
    @NSManaged var myMovieTitle: String
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(myMoviePoster: String, myMovieSynopsis: String, myMovieTitle: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("MyMovie", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.myMoviePoster = myMoviePoster
        
    }
    

}