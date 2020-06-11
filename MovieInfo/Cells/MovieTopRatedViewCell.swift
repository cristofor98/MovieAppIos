//
//  MovieTopRatedViewCell.swift
//  MovieInfo
//
//  Created by tekwill on 6/5/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import UIKit
import Kingfisher

class MovieTopRatedViewCell: UICollectionViewCell {
    
    var movie: Movie? {
        didSet{
            if let movie = movie {
                movieImagine.kf.setImage(with: movie.posterURL)
            }
        }
    }
    @IBOutlet private weak var movieImagine: UIImageView!
}

//extension String{
//    var url: URL? {
//        return URL(string: "\(posterUrl)\(self)")
//    }
//}
