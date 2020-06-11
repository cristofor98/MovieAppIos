//
//  MovieBackdropTableViewCell.swift
//  MovieInfo
//
//  Created by tekwill on 6/5/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

public class MovieBackdropTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    
    public static var nib: UINib {
        return UINib(nibName: "MovieBackdropTableViewCell", bundle: Bundle(for: MovieBackdropTableViewCell.self))
    }
    
    public var imageURL: URL? {
        didSet {
            backdropImageView.kf.setImage(with: imageURL)
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backdropImageView.kf.indicatorType = .activity

    }
    
}
