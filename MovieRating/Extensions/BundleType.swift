//
//  BundleType.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 30/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//

import Foundation

protocol BundleType: class {
    static var bundle: Bundle { get }
}

extension BundleType {
    static var bundle: Bundle {
        return Bundle(for: Self.self)
    }
}
