//
//  NetworkSessionMock.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 28/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//

import Foundation

public struct NetworkSessionMock: NetworkSession {
    private let networkResult: NetworkResult<JSON, NetworkError>
    
    public init(networkResult: NetworkResult<JSON, NetworkError>) {
        self.networkResult = networkResult
    }
    
    public func loadData(from url: URL, completionHandler: @escaping (NetworkResult<JSON, NetworkError>) -> Void) {
        completionHandler(networkResult)
    }
}
