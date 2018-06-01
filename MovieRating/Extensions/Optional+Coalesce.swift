//
//  Optional+Coalesce.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 31/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//

public protocol OptionalType {
    associatedtype Wrapped
    
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? {
        return self
    }
}

extension OptionalType {
    public func coalesceWith(_ value: @autoclosure () -> Wrapped) -> Wrapped {
        return self.optional ?? value()
    }
}
