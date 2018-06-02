//: [Previous](@previous)

import UIKit
import MovieRatingFramework
import PlaygroundSupport

// Paths
let nowPlaying = "now_playing"
let topRated = "top_rated"

// Success mockup
let movieListMockupJSON1 = "movieList1"
let movieListMockupJSON2 = "movieList2"

let mockupJSON = Bundle.loadJSONFile(name: movieListMockupJSON2)!
let mockupSuccessNetworkSession = NetworkSessionMock(networkResult: NetworkResult(value: mockupJSON))

// Failure mockup
let mockupFailureNetworkSession = NetworkSessionMock(networkResult: NetworkResult(error: NetworkError.invalidData))

// Let's start testing
let networkManager = NetworkManager(session: mockupSuccessNetworkSession)
let viewController = MovieListViewController(path: topRated, networkManager: networkManager)

let (parrentVC, _) = traitControllers(device: .phone5_8inch,
                                      orientation: .portrait,
                                      child: viewController)

PlaygroundPage.current.liveView = parrentVC.view
