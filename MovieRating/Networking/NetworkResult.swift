//
//  NetworkResult.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 19/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//

protocol ResultProtocol {
    associatedtype Value
    associatedtype Error: Swift.Error
    
    init(value: Value)
    
    init(error: Error)
}

enum NetworkResult<T, Error: Swift.Error>: ResultProtocol {
    case success(T)
    case failure(Error)
    
    init(value: T) {
        self = .success(value)
    }
    
    init(error: Error) {
        self = .failure(error)
    }
}

enum NetworkError: Swift.Error {
    case invalidData
    case underlying(Swift.Error)
    
    init(error: Swift.Error) {
        self = .underlying(error)
    }
}
