//
//  NetworkManager.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 19/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//

import Foundation

public final class NetworkManager {
    private let host = "api.themoviedb.org"   //"https://image.tmdb.org/t/p/w342"
    private let scheme = "https"
    private let apiKey = "dc252f7444d39f39197952cf36f30ee4" //a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    private let session: NetworkSession = AppConfigurationManager.current.networkSession
    
    public init() {  }
    
    private func loadData(from url: URL, completionHandler: @escaping (NetworkResult<JSON, NetworkError>) -> Void) {
        session.loadData(from: url, completionHandler: completionHandler)
    }
    
    func requestMovieList(path: String, completion: @escaping ([Movie]) -> Void) {
        let parameters = [
            "api_key": apiKey,
            "language": "en-US",
            "page": "1"
        ]
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/3/movie/\(path)"
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            completion([])
            return
        }
        
        loadData(from: url) { result in
            switch result {
            case .success(let json):
                let moviesJSON = json["results"] as? [JSON]
                let movies = moviesJSON?.map { Movie(json: $0) }
                completion(movies ?? [])
            case .failure(let error):
                completion([])
                print("⚠️ \(error) ⚠️")
            }
        }
    }
}
