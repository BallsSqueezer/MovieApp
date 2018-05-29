//
//  NetworkResult.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 19/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//

public protocol ResultProtocol {
    associatedtype Value
    associatedtype Error: Swift.Error
    
    init(value: Value)
    
    init(error: Error)
}

public enum NetworkResult<T, Error: Swift.Error>: ResultProtocol {
    case success(T)
    case failure(Error)
    
    public init(value: T) {
        self = .success(value)
    }
    
    public init(error: Error) {
        self = .failure(error)
    }
}

public enum NetworkError: Swift.Error {
    case invalidData
    case underlying(Swift.Error)
    
    init(error: Swift.Error) {
        self = .underlying(error)
    }
}
