//
//  NetworkSession.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 19/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//
import Foundation

protocol NetworkSession {
    func loadData(from url: URL, completionHandler: @escaping (NetworkResult<JSON, NetworkError>) -> Void)
}

extension URLSession: NetworkSession {
    func loadData(from url: URL, completionHandler: @escaping (NetworkResult<JSON, NetworkError>) -> Void) {
        let task = dataTask(with: url) { (data, _, error) in
            if let error = error {
                let err = NetworkError(error: error)
                completionHandler(NetworkResult(error: err))
                return
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON ?? [:]
                    completionHandler(NetworkResult(value: json))
                } catch let error {
                    let err = NetworkError(error: error)
                    completionHandler(NetworkResult(error: err))
                }
            } else {
                completionHandler(.failure(NetworkError.invalidData))
            }
        }
        task.resume()
    }
}
