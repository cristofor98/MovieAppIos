//
//  MovieRepository.swift
//  MovieKit
//
//  Created by Alfian Losari on 11/24/18.
//  Copyright © 2018 Alfian Losari. All rights reserved.
//

import Foundation
import Alamofire

private let apiKey = ""
private let baseAPIURL = "https://api.themoviedb.org/3"
private let coder = JSONDecoder()
private let getTokenMethod = "/authentication/token/new"

public class MovieStore: MovieService {
    
    public static let shared = MovieStore()
    private init() {}
    private let urlSession = URLSession.shared
 
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    
    public func fetchMovies(_ page: Int, from endpoint: Endpoint, params: [String: String]? = nil, successHandler: @escaping (_ response: MoviesResponse) -> Void, errorHandler: @escaping(_ error: Error) -> Void) {
        
        guard var urlComponents = URLComponents(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)") else {
            errorHandler(MovieError.invalidEndpoint)
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if page != 1  {
            let pagestring = String(page)
            queryItems.append(URLQueryItem(name: "page", value: pagestring))
        }
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            errorHandler(MovieError.invalidEndpoint)
            return
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.handleError(errorHandler: errorHandler, error: MovieError.apiError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.handleError(errorHandler: errorHandler, error: MovieError.invalidResponse)
                return
            }
            
            guard let data = data else {
                self.handleError(errorHandler: errorHandler, error: MovieError.noData)
                return
            }
            
            do {
                let moviesResponse = try self.jsonDecoder.decode(MoviesResponse.self, from: data)
                DispatchQueue.main.async {
                    successHandler(moviesResponse)
                }
            } catch {
                self.handleError(errorHandler: errorHandler, error: MovieError.serializationError)
            }
        }.resume()
        
    }
    
    
    public func fetchMovie(id: Int, successHandler: @escaping (_ response: Movie) -> Void, errorHandler: @escaping(_ error: Error) -> Void) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)?api_key=\(apiKey)&append_to_response=videos,credits") else {
            handleError(errorHandler: errorHandler, error: MovieError.invalidEndpoint)
            return
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.handleError(errorHandler: errorHandler, error: MovieError.apiError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.handleError(errorHandler: errorHandler, error: MovieError.invalidResponse)

                return
            }
            
            guard let data = data else {
                self.handleError(errorHandler: errorHandler, error: MovieError.noData)
                return
            }
            
            do {
                let movie = try self.jsonDecoder.decode(Movie.self, from: data)
                DispatchQueue.main.async {
                    successHandler(movie)
                }
            } catch {
                self.handleError(errorHandler: errorHandler, error: MovieError.serializationError)
            }
        }.resume()
    
    }
    
    func searchMovie(query: String, params: [String : String]?, successHandler: @escaping (MoviesResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        guard var urlComponents = URLComponents(string: "\(baseAPIURL)/search/movie") else {
            errorHandler(MovieError.invalidEndpoint)
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                          URLQueryItem(name: "language", value: "en-US"),
                          URLQueryItem(name: "include_adult", value: "false"),
                          URLQueryItem(name: "region", value: "US"),
                          URLQueryItem(name: "query", value: query)
                          ]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            errorHandler(MovieError.invalidEndpoint)
            return
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.handleError(errorHandler: errorHandler, error: MovieError.apiError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.handleError(errorHandler: errorHandler, error: MovieError.invalidResponse)
                return
            }
            
            guard let data = data else {
                self.handleError(errorHandler: errorHandler, error: MovieError.noData)
                return
            }
            
            do {
                let moviesResponse = try self.jsonDecoder.decode(MoviesResponse.self, from: data)
                DispatchQueue.main.async {
                    successHandler(moviesResponse)
                }
            } catch {
                self.handleError(errorHandler: errorHandler, error: MovieError.serializationError)
            }
            }.resume()
        
    }
    
    
    public func requestToken( params: [String: String]? = nil, successHandler: @escaping (_ response: Token) -> Void, errorHandler: @escaping(_ error: Error) -> Void) {
           
           guard var urlComponents = URLComponents(string:"\(baseAPIURL)/authentication/token/new"
) else {
               errorHandler(MovieError.invalidEndpoint)
               return
           }
           
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        urlComponents.queryItems = queryItems
           
           guard let url = urlComponents.url else {
               errorHandler(MovieError.invalidEndpoint)
               return
           }
           
           urlSession.dataTask(with: url) { (data, response, error) in
               if error != nil {
                   self.handleError(errorHandler: errorHandler, error: MovieError.apiError)
                   return
               }
               
               guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                   self.handleError(errorHandler: errorHandler, error: MovieError.invalidResponse)
                   return
               }
               
               guard let data = data else {
                   self.handleError(errorHandler: errorHandler, error: MovieError.noData)
                   return
               }
               
               do {
                   let token = try self.jsonDecoder.decode(Token.self, from: data)
                   DispatchQueue.main.async {
                       successHandler(token)
                   }
               } catch {
                   self.handleError(errorHandler: errorHandler, error: MovieError.serializationError)
               }
           }.resume()
       }
    
    public func login(requestToken: String,username: String,password: String, params: [String: String]? = nil, successHandler: @escaping (_ response: Token) -> Void, errorHandler: @escaping(_ error: Error) -> Void) {
        
        guard var urlComponents = URLComponents(string:"\(baseAPIURL)/authentication/token/validate_with_login"
            ) else {
                errorHandler(MovieError.invalidEndpoint)
                return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        queryItems.append(URLQueryItem(name: "request_token", value: requestToken))
        queryItems.append(URLQueryItem(name: "username", value: username))
        queryItems.append(URLQueryItem(name: "password", value: password))
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            errorHandler(MovieError.invalidEndpoint)
            return
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.handleError(errorHandler: errorHandler, error: MovieError.apiError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.handleError(errorHandler: errorHandler, error: MovieError.invalidResponse)
                return
            }
            
            guard let data = data else {
                self.handleError(errorHandler: errorHandler, error: MovieError.noData)
                return
            }
            
            do {
                let token = try self.jsonDecoder.decode(Token.self, from: data)
                DispatchQueue.main.async {
                    successHandler(token)
                }
            } catch {
                self.handleError(errorHandler: errorHandler, error: MovieError.serializationError)
            }
        }.resume()
    }
    
    public func getSessionId(requestToken: String, params: [String: String]? = nil, successHandler: @escaping (_ response: Session) -> Void, errorHandler: @escaping(_ error: Error) -> Void) {
           
           guard var urlComponents = URLComponents(string:"\(baseAPIURL)/authentication/session/new"
               ) else {
                   errorHandler(MovieError.invalidEndpoint)
                   return
           }
           
           var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
           queryItems.append(URLQueryItem(name: "request_token", value: requestToken))
           if let params = params {
               queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
           }
           urlComponents.queryItems = queryItems
           
           guard let url = urlComponents.url else {
               errorHandler(MovieError.invalidEndpoint)
               return
           }
           
           urlSession.dataTask(with: url) { (data, response, error) in
               if error != nil {
                   self.handleError(errorHandler: errorHandler, error: MovieError.apiError)
                   return
               }
               
               guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                   self.handleError(errorHandler: errorHandler, error: MovieError.invalidResponse)
                   return
               }
               
               guard let data = data else {
                   self.handleError(errorHandler: errorHandler, error: MovieError.noData)
                   return
               }
               
               do {
                   let session = try self.jsonDecoder.decode(Session.self, from: data)
                   DispatchQueue.main.async {
                       successHandler(session)
                   }
               } catch {
                   self.handleError(errorHandler: errorHandler, error: MovieError.serializationError)
               }
           }.resume()
       }
    
    public func getUserDetails(sessionId: String, params: [String: String]? = nil, successHandler: @escaping (_ response: UserId) -> Void, errorHandler: @escaping(_ error: Error) -> Void) {
              
              guard var urlComponents = URLComponents(string:"\(baseAPIURL)/account"
                  ) else {
                      errorHandler(MovieError.invalidEndpoint)
                      return
              }
              
              var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
              queryItems.append(URLQueryItem(name: "session_id", value: sessionId))
              if let params = params {
                  queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
              }
              urlComponents.queryItems = queryItems
              
              guard let url = urlComponents.url else {
                  errorHandler(MovieError.invalidEndpoint)
                  return
              }
              
              urlSession.dataTask(with: url) { (data, response, error) in
                  if error != nil {
                      self.handleError(errorHandler: errorHandler, error: MovieError.apiError)
                      return
                  }
                  
                  guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                      self.handleError(errorHandler: errorHandler, error: MovieError.invalidResponse)
                      return
                  }
                  
                  guard let data = data else {
                      self.handleError(errorHandler: errorHandler, error: MovieError.noData)
                      return
                  }
                  
                  do {
                      let userId = try self.jsonDecoder.decode(UserId.self, from: data)
                      DispatchQueue.main.async {
                          successHandler(userId)
                      }
                  } catch {
                      self.handleError(errorHandler: errorHandler, error: MovieError.serializationError)
                  }
              }.resume()
          }
    
    public func getFavoritMovies(accoundId: Int,sessionId: String, params: [String: String]? = nil, successHandler: @escaping (_ response: MoviesResponse) -> Void, errorHandler: @escaping(_ error: Error) -> Void) {
                 
                 guard var urlComponents = URLComponents(string:"\(baseAPIURL)/account/\(accoundId)/favorite/movies"
                     ) else {
                         errorHandler(MovieError.invalidEndpoint)
                         return
                 }
                 
                 var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
                 queryItems.append(URLQueryItem(name: "session_id", value: sessionId))
                 if let params = params {
                     queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
                 }
                 urlComponents.queryItems = queryItems
                 
                 guard let url = urlComponents.url else {
                     errorHandler(MovieError.invalidEndpoint)
                     return
                 }
                 
                 urlSession.dataTask(with: url) { (data, response, error) in
                     if error != nil {
                         self.handleError(errorHandler: errorHandler, error: MovieError.apiError)
                         return
                     }
                     
                     guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                         self.handleError(errorHandler: errorHandler, error: MovieError.invalidResponse)
                         return
                     }
                     
                     guard let data = data else {
                         self.handleError(errorHandler: errorHandler, error: MovieError.noData)
                         return
                     }
                     
                     do {
                         let favoritmovies = try self.jsonDecoder.decode(MoviesResponse.self, from: data)
                         DispatchQueue.main.async {
                             successHandler(favoritmovies)
                         }
                     } catch {
                         self.handleError(errorHandler: errorHandler, error: MovieError.serializationError)
                     }
                 }.resume()
             }
    
    private func handleError(errorHandler: @escaping(_ error: Error) -> Void, error: Error) {
        DispatchQueue.main.async {
            errorHandler(error)
        }
    }
    
}
