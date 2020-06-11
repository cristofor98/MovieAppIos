//
//  MovieService.swift
//  MovieInfo
//
//  Created by Alfian Losari on 10/03/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation

protocol MovieService {
    
    func fetchMovies(_ page: Int, from endpoint: Endpoint, params: [String: String]?, successHandler: @escaping (_ response: MoviesResponse) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    func fetchMovie(id: Int, successHandler: @escaping (_ response: Movie) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    func searchMovie(query: String, params: [String: String]?, successHandler: @escaping (_ response: MoviesResponse) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    func requestToken(params: [String: String]?, successHandler: @escaping (_ response: Token) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    func login(requestToken: String,username: String,password: String,params: [String: String]?, successHandler: @escaping (_ response: Token) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    func getSessionId(requestToken: String,params: [String: String]?, successHandler: @escaping (_ response: Session) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    func getUserDetails(sessionId: String,params: [String: String]?, successHandler: @escaping (_ response: UserId) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    func getFavoritMovies(accoundId: Int,sessionId: String,params: [String: String]?, successHandler: @escaping (_ response: MoviesResponse) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
}


public enum Endpoint: String, CustomStringConvertible, CaseIterable {
    case nowPlaying = "now_playing"
    case upcoming
    case popular
    case topRated = "top_rated"
    
    public var description: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .upcoming: return "Upcoming"
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        }
    }
    
    public init?(index: Int) {
        switch index {
        case 0: self = .nowPlaying
        case 1: self = .popular
        case 2: self = .upcoming
        case 3: self = .topRated
        default: return nil
        }
    }
    
    public init?(description: String) {
        guard let first = Endpoint.allCases.first(where: { $0.description == description }) else {
            return nil
        }
        self = first
    }
    
}

public enum MovieError: Error, CustomNSError {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String{
        switch  self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
   public var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}
