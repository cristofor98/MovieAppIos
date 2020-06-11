//
//  AccountViewController.swift
//  MovieInfo
//
//  Created by tekwill on 6/10/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var lable: UILabel!
    
    var movieCovers = [UIImage]()
    var userid: Int = 0
    var page: Int = 0
    var sessionId: String = ""
    let movieService: MovieService = MovieStore.shared
    
    var movies = [Movie]() {
           didSet {
               collectionView.reloadData()
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title="Account"
        collectionView.dataSource = self
        collectionView.delegate = self
        NotificationCenter.default.addObserver(AccountViewController(), selector: #selector(didGetUsername(_:)), name: Notification.Name("username"), object: nil)
        NotificationCenter.default.addObserver(AccountViewController(), selector: #selector(didGetUserId(_:)), name: Notification.Name("userid"), object: nil)
        NotificationCenter.default.addObserver(AccountViewController(), selector: #selector(didGetSessionId(_:)), name: Notification.Name("sessionid"), object: nil)
        print(userid)
        print(sessionId + "adfafa")
        fetchMovies()
    }
    
    private func fetchMovies() {
        self.movies = []
        
        self.movieService.getFavoritMovies(accoundId: self.userid,sessionId: self.sessionId,params: nil, successHandler: {[unowned self] (response) in
            self.movies = response.results
            self.page = response.page
            print(self.page)
        }) { [unowned self] (error) in
            print("error in receiving movies")
        }
    }
    
    
    @objc func didGetUsername(_ notification: Notification){
        let text = notification.object as! String?
      //  lable.text = text
    }
    
    @objc func didGetUserId(_ notification: Notification){
         let id = notification.object as! Int?
         userid = id!
         print(userid)
        print("adafadfa")
     }
    
    @objc func didGetSessionId(_ notification: Notification){
        let sessionid = notification.object as! String?
        sessionId = sessionid!
        print(sessionId)
        print("sfsdfsdfs")
    }
    
}

extension AccountViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Favorite", for: indexPath) as! MovieTopRatedViewCell
        
        cell.movie = movies[indexPath.item]
        return cell
    }
}
