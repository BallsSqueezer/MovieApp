//: [Previous](@previous)

import UIKit
import MovieRatingFramework
import PlaygroundSupport

let content1 = WalkthroughContent(heading: "Personalize",
                                  imageFile: "walkthru1",
                                  content: "We have everything that suits your style")

let content2 = WalkthroughContent(heading: "Discover",
                                  imageFile: "walkthru4",
                                  content: "Searching for your favourite movies can't never be easier")

let content3 = WalkthroughContent(heading: "Enjoyable",
                                  imageFile: "walkthru5",
                                  content: "Enjoy you favourite movies with friends and family")

let walkthroughContentViewController = WalkthroughContentViewController()
walkthroughContentViewController.walkthroughContent = content3
walkthroughContentViewController.view.frame.size = CGSize(width: 375, height: 667)

PlaygroundPage.current.liveView = walkthroughContentViewController.view


