//
//  MyMovieTableViewCell.swift
//  movieMagic
//
//  Created by Stella Su on 4/15/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//

import UIKit

class MyMovieTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var myMoviePoster: UIImageView!
    @IBOutlet weak var myMovieTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
