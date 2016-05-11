//
//  MovieTableViewCell.swift
//  movieMagic
//
//  Created by Stella Su on 4/12/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    var model: Movie? {
        didSet {
            guard let newMovie = self.model else  { return }
            self.movieTitleLabel.text = newMovie.title
            self.movieDescriptionLabel.text = newMovie.description
            self.moviePosterImageView.image = .None
        }
    }
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    func updateDisplayImages(newImage: UIImage) {
        self.moviePosterImageView.image = newImage
    }
    
    var posterURL: NSURL?


}
