//
//  TopRatedMovieListViewController.swift
//  MovieInfo
//
//  Created by tekwill on 6/5/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import UIKit

class TopRatedMovieListViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let movieService: MovieService = MovieStore.shared
    private var page: Int = 1
    private var totalPages: Int = 0
    
    var movies = [Movie]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var endpoint = Endpoint.topRated {
        didSet {
            fetchMovies()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Rated"
        let width = (view.frame.size.width - 20) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 190)
    
        fetchMovies()
    }
    
    private func fetchMovies() {
        self.movies = []
        activityIndicatorView.startAnimating()
        
        movieService.fetchMovies(page,from: endpoint, params: nil, successHandler: {[unowned self] (response) in
            self.activityIndicatorView.stopAnimating()
            self.movies = response.results
            self.totalPages = response.totalPages
        }) { [unowned self] (error) in
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    private func loadMoreData(){
        if page < totalPages {
            page += 1
            activityIndicatorView.startAnimating()
            OperationQueue.main.addOperation {
                self.movieService.fetchMovies(self.page,from: self.endpoint, params: nil, successHandler: {[unowned self] (response) in
                    self.activityIndicatorView.stopAnimating()
                    self.movies += response.results
                    self.collectionView.reloadData()
                }) { [unowned self] (error) in
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }
    }
}

extension  TopRatedMovieListViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopRated", for: indexPath) as! MovieTopRatedViewCell
        cell.movie = movies[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        let count = movies.count
        if indexPath.item == count - 1 {
            self.loadMoreData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieDetailVC = segue.destination as? MovieDetailViewController, let indexPath = sender as? IndexPath else {
           fatalError("Unexpected View Controller")
        }
          let movie = movies[indexPath.item]
          movieDetailVC.movie = movie
      }
}
