//: [Previous](@previous)

import UIKit
import MovieRatingFramework
import PlaygroundSupport

let bundle = Bundle.init(for: MovieListViewController.self)

// Success mockup
let movieListMockupJSON1 = "movieList1"
let movieListMockupJSON2 = "movieList2"

let mockupJSON = Bundle.loadJSONFile(name: movieListMockupJSON2, inBundle: bundle)!
let mockupSuccessNetworkSession = NetworkSessionMock(networkResult: NetworkResult(value: mockupJSON))

// Failure mockup
let mockupFailureNetworkSession = NetworkSessionMock(networkResult: NetworkResult(error: NetworkError.invalidData))

// Let's start testing
let networkManager = NetworkManager(session: mockupSuccessNetworkSession)
let viewController = MovieListViewController(networkManager: networkManager)
viewController.view.frame.size = CGSize(width: 375, height: 667)

PlaygroundPage.current.liveView = viewController.view
