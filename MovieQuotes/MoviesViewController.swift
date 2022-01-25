//
//  ViewController.swift
//  MovieQuotes
//
//  Created by admin on 20/12/2021.
//

import UIKit

class MoviesViewController: UIViewController {
    
    private let key = "ab63c21c51099016696ec8784807ecda"
    var search = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var moviesCollcetionView: UICollectionView!
    
    var moviesDetailsList = [Result]()
    var moviesImageList = [Int : UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        moviesCollcetionView.dataSource = self
        moviesCollcetionView.delegate = self
        searchBar.delegate = self
    }
    
    func gettingDataFromAPI(){
        //Replaceing Spaces With Somthing API can Read
        search = search.replacingOccurrences(of: " ", with: "%20")
        // specify the url that we will be sending the GET request to
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(key)&query=\(search)&page=1")
        // create a URLSession to handle the request tasks
        let session = URLSession.shared
        // create a "data task" to make the request and run completion handler
        let task = session.dataTask(with: url!, completionHandler: {
            data, response, error in
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(MoviesAPIModel.self, from: data!)

                self.moviesDetailsList = decoded.results

                DispatchQueue.main.async {
                    self.gettingMoviesImages()
                }
            } catch {
                print("Failed to decode JSON \(error)")
            }
        })
        task.resume()
    }

    func gettingMoviesImages() {
        moviesImageList.removeAll()
        for moviesDetails in moviesDetailsList {
            guard let moviePosterUrl = moviesDetails.posterPath else { continue }
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(moviePosterUrl)") else { continue }
            // create a URLSession to handle the request tasks
            let session = URLSession.shared
            // create a "data task" to make the request and run completion handler
            let task = session.dataTask(with: url, completionHandler: {
                data, response, error in
                guard let data = data else {
                    return
                }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.moviesImageList[moviesDetails.id] = image
                    self.moviesCollcetionView.reloadData()
                }
            })
            task.resume()
        }
    }
    
    func MovieImage(movieID: Int) -> UIImage {
        for movieImage in moviesImageList {
            if (movieImage.key == movieID) {
                return movieImage.value
            }
        }
        
        guard let defaultImage = UIImage(named: "defaultImage") else { return UIImage() }
        return defaultImage
    }
}

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesDetailsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCustomCollectionViewCell
        cell.movieNameLabel.text = moviesDetailsList[indexPath.row].title
        cell.movieImageView.image = MovieImage(movieID: moviesDetailsList[indexPath.row].id)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.movieDetailsLabel.text = moviesDetailsList[indexPath.row].overview
        movieDetailsViewController.movieImageView.image = MovieImage(movieID: moviesDetailsList[indexPath.row].id)
        self.present(movieDetailsViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.width / 2.0 - 10
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let newSearch = searchBar.text {
            search = newSearch
            gettingDataFromAPI()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.searchTextField.isHighlighted = false
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        let autoCompleteViewController = AutoComleteViewController()
        autoCompleteViewController.autoComleteDelegate = self
        self.present(autoCompleteViewController, animated: true, completion: nil)
    }
}

extension MoviesViewController: AutoCompleteDelegate {
    func autoCompleteSelected(selectedName name: String) {
        searchBar.text = name
        search = name
        gettingDataFromAPI()
    }
}
