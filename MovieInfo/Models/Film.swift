//
//  Film.swift
//  MovieInfo
//
//  Created by tekwill on 6/9/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Foundation

public struct Film: Codable {

 public let id: Int
 public let title: String
 public let backdropPath: String?
 public let posterPath: String?
 public let overview: String
 public let releaseDate: String
 public let voteAverage: Double
 public let voteCount: Int
 public let tagline: String?
 public let adult: Bool
 public let runtime: Int?
 public var posterURL: URL {
    return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
 }
}
