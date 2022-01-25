//
//  MovieDetailsViewController.swift
//  MovieQuotes
//
//  Created by admin on 20/12/2021.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    var movieDetailsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: -2, height: -2)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(movieImageView)
        view.addSubview(movieDetailsLabel)
        movieImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        if movieDetailsLabel.text!.isEmpty {
            movieDetailsLabel.text = "No Data"
        }
        
        NSLayoutConstraint.activate([
            movieDetailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            movieDetailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            movieDetailsLabel.topAnchor.constraint(equalTo: view.topAnchor),
            movieDetailsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
