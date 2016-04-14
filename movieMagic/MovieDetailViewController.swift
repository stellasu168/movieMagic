//
//  MovieDetailViewController.swift
//  movieMagic
//
//  Created by Stella Su on 4/13/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieDetailView: UITextView!
    @IBOutlet weak var movieTitle: UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        //moviePoster.image = movie?.posterURL
        movieDetailView.text = movie?.description // using optional chaining
        movieTitle.text = movie?.title
        
    }


 
}
