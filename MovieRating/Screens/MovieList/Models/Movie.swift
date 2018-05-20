//
//  Movie.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 7/9/16.
//  Copyright © 2016 Hien Tran. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let title: String?
    let posterPath: String?
    let adult: Bool
    let overview: String?
    let voteCount: Int
    let voteAverage: Double
    let releaseDate: String?
    
    init(json: JSON) {
        self.title = json["title"] as? String
        self.posterPath = json["poster_path"] as? String
        self.adult = json["adult"] as? Bool ?? false
        self.overview = json["overview"] as? String
        self.voteCount = json["vote_count"] as? Int ?? 0
        self.voteAverage = json["vote_average"] as? Double ?? 0.0
        self.releaseDate = json["release_date"] as? String
    }
}
