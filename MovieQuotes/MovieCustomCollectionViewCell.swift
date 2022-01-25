//
//  MovieCustomCollectionViewCell.swift
//  MovieQuotes
//
//  Created by admin on 20/12/2021.
//

import UIKit

class MovieCustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieNameLabel.shadowColor = .black
        movieNameLabel.shadowOffset = CGSize(width: -2, height: -2)
        movieNameLabel.layer.shadowColor = UIColor.black.cgColor
        movieNameLabel.layer.shadowRadius = 3.0
        movieNameLabel.layer.shadowOpacity = 1.0
        movieNameLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        movieNameLabel.layer.masksToBounds = false
    }
}
