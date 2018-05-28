//
//  WalkthroughContent.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 24/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//

public struct WalkthroughContent {
    let index: Int
    let heading: String
    let imageFile: String
    let content: String
    
    public init(
        index: Int,
        heading: String,
        imageFile: String,
        content: String)
    {
        self.index = index
        self.heading = heading
        self.imageFile = imageFile
        self.content = content
    }
    
}
