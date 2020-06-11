//
//  Token.swift
//  MovieInfo
//
//  Created by tekwill on 6/10/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Foundation

public struct Token : Codable {
    public let success: Bool
    public let expiresAt: String
    public let requestToken: String
}
