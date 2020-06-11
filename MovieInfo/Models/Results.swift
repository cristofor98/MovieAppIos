//
//  Results.swift
//  MovieInfo
//
//  Created by tekwill on 6/5/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Foundation
 
public struct Results: Codable {
    public let page: Int
    public let totalResults: Int
    public let totalPages: Int
    public let results: [Film]
}
