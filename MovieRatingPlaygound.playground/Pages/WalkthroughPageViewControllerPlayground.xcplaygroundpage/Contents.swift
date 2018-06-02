//: [Previous](@previous)

import UIKit
import MovieRatingFramework
import PlaygroundSupport

AppConfigurationManager.updateCurrentConfig(language: .ja)

let walkthroughViewModel = WalkthroughViewModel()
let walkthroughPageViewController = WalkthroughPageViewController(viewModel: walkthroughViewModel)



let (parentVC, _) = traitControllers(device: .phone5_5inch,
                                     orientation: .portrait,
                                     child: walkthroughPageViewController)

PlaygroundPage.current.liveView = parentVC.view
