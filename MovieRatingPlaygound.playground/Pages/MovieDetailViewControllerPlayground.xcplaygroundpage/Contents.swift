//: Playground - noun: a place where people can play

import UIKit
import MovieRatingFramework
import PlaygroundSupport

let movieMockup1 = "movie1"
let movieMockup2 = "movie2"
let movieMockup3 = "movie3"

let bundle = Bundle.init(for: MovieDetailViewController.self)
let mockupJSON = Bundle.loadJSONFile(name: movieMockup1, inBundle: bundle)!
let movie = Movie(json: mockupJSON)

let movieDetailViewController = MovieDetailViewController()
movieDetailViewController.movie = movie

let (parentVC, _) = traitControllers(device: .phone5_5inch,
                                     orientation: .portrait,
                                     child: movieDetailViewController)

PlaygroundPage.current.liveView = parentVC.view
