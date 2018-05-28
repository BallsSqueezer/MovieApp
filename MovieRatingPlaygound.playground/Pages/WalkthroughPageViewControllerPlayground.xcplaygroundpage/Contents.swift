//: [Previous](@previous)

import UIKit
import MovieRatingFramework
import PlaygroundSupport

let walkthroughViewModel = WalkthroughViewModel()

let walkthroughPageViewController = WalkthroughPageViewController(viewModel: walkthroughViewModel)
walkthroughPageViewController.view.frame.size = CGSize(width: 375, height: 667)
PlaygroundPage.current.liveView = walkthroughPageViewController.view
