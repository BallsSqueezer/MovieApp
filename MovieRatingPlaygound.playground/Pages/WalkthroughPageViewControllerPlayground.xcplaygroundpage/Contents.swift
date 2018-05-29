//: [Previous](@previous)

import UIKit
import MovieRatingFramework
import PlaygroundSupport

let walkthroughViewModel = WalkthroughViewModel()

let walkthroughPageViewController = WalkthroughPageViewController(viewModel: walkthroughViewModel)

let (parentVC, _) = traitControllers(device: .pad,
                                     orientation: .portrait,
                                     child: walkthroughPageViewController)

PlaygroundPage.current.liveView = parentVC.view
