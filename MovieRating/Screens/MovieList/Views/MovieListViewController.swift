//
//  MovieListViewController.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 7/6/16.
//  Copyright © 2016 Hien Tran. All rights reserved.
//

import UIKit
import AFNetworking
import QuartzCore

final class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let networkManager = NetworkManager()
    
    private let viewModel = MovieListViewModel()
    
    private var isSearchActive: Bool = false
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = UIColor(r: 51, g: 51, b: 51, a: 1)
        tableView.separatorColor = .lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.indicatorStyle = .white
        tableView.keyboardDismissMode = .interactive
        tableView.insertSubview(refreshControl, at: 0)
        tableView.register(MovieCell.self)
        tableView.delegate = self
        tableView.dataSource  = self
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search for movie titles..."
        controller.searchBar.prompt = "This is lit"
        controller.searchBar.tintColor = .lightGray
        controller.searchBar.searchBarStyle = .minimal
        definesPresentationContext = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.delegate = self
        return controller
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        return control
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.title = "Movie Rating"
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.titleView = searchController.searchBar
        
        view = tableView
        
        networkManager.requestMovieList { [weak self] movies in
            self?.viewModel.updateMovieList(movies)
            
            DispatchQueue.main.async {
                self?.navigationItem.titleView = self?.searchController.searchBar
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //check if user uses app for the first time
//        let defaults = UserDefaults.standard
//        let hasViewWalkthrough = defaults.bool(forKey: "hasViewWalkthrough")

//        if hasViewWalkthrough {
//            return
//        }
//
//        //if firstTime, walk them thru
//        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? WalkthroughPageViewController{
//            present(pageViewController, animated: true, completion: nil)
//        }
    }
    
//MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = viewModel.item(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as MovieCell

        cell.titleLabel.text = movie.title?.capitalized
        cell.voteCountLabel.text = "\(movie.voteCount)" + " votes"
        cell.ratingLabel.text = String(format: "%.1f", movie.voteAverage)
        if movie.voteAverage >= 5.0{
            cell.ratingLabel.backgroundColor = UIColor(red: 164.0/255.0, green: 198.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        } else{
            cell.ratingLabel.backgroundColor = UIColor.red
        }

        cell.dateLabel.text = movie.releaseDate
        cell.overviewLabel.text = movie.overview
        
        //made the poster image fade in
        let fullPosterUrl = "https://image.tmdb.org/t/p/w342" + movie.posterPath!
        let url = URL(string: fullPosterUrl)!
        let imageRequest = URLRequest(url: url)
        
        
        cell.posterImageView.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                if imageResponse != nil{
                    cell.posterImageView.alpha = 0.0
                    cell.posterImageView.image = image
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.posterImageView.alpha = 1.0
                    })
                } else{
                    cell.posterImageView.image = image
                }
            },
            failure: nil
        )

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func prepare(for_  segue: UIStoryboardSeguheightForRowAt    if segue.identifier == "MovieDetailFromRow"{
//            let controller = segue.destination as! MovieDetailViewController
//
//            if let indexPath = tableView.indexPathForSelectedRow{
//                controller.movie = searchController.isActive ? searchResults[indexPath.row] : movies[indexPath.row]
//                controller.hidesBottomBarWhenPushed = true
//            }
//        } else if segue.identifier == "MovieDetailFromGrid"{
//            let controller = segue.destination as! MovieDetailViewController
//
//            if let indexPaths = collectionView.indexPathsForSelectedItems {
//                if let indexPath = indexPaths.first {
//                    controller.movie = searchController.isActive ? searchResults[indexPath.row] : movies[indexPath.row]
//                    controller.hidesBottomBarWhenPushed = true
//                }
//            }
//        }
//    }
    
    private func showNetworkError(){
        let alert = UIAlertController(title: "Whoops", message: "Network Error. Plese check your network connection", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func refreshControlAction(_ refreshControl: UIRefreshControl) {
        networkManager.requestMovieList { [weak self] movies in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                if movies.count > 0 {
                    self?.viewModel.updateMovieList(movies)
                } else {
                    self?.showNetworkError()
                }
            }
        }
    }
}

extension MovieListViewController: MovieListViewModelDelegate {
    func modelDidChange() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension MovieListViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        viewModel.activateSearch()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        viewModel.resetSearchList()
    }
}

extension MovieListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            viewModel.searchTitle(searchText)
        }
    }
}
