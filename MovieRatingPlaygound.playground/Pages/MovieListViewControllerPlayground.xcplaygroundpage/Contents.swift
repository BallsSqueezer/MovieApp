//: [Previous](@previous)

import UIKit
import MovieRatingFramework
import PlaygroundSupport

let viewController = MovieListViewController()
viewController.view.frame.size = CGSize(width: 375, height: 667)

PlaygroundPage.current.liveView = viewController.view
