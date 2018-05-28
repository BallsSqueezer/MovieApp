//: [Previous](@previous)

import UIKit
import MovieRatingFramework
import PlaygroundSupport


UserDefaults.standard.set(true, forKey: UserDefault.Walkthrough.didWatchWalkthrough)

let viewController = MovieListViewController()
viewController.view.frame.size = CGSize(width: 375, height: 667)

PlaygroundPage.current.liveView = viewController.view
