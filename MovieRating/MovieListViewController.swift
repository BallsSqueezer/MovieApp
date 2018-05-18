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

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//MARK: - Outlets and Variables
    var movies: [Movie] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var switchViewButton: UIBarButtonItem!
    
    let baseUrl = "https://image.tmdb.org/t/p/w342"
    
    var endpoint: String!
    
    var navigationTitle: String!
    
    var isLoading = false //store the loading stage
    
    var searchController: UISearchController!
    var searchResults: [Movie] = []
    
    var inTableView = true
    var mask: CALayer?
    
//MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = navigationTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        isLoading = true
        
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        
        //display tableview/gridview based on last time
        let defauls = UserDefaults.standard
        inTableView = defauls.bool(forKey: "switchView")
        
        print(inTableView)
        let fromView = inTableView ? tableView : collectionView
        let toView = inTableView ? collectionView : tableView
        toView.alpha = 0
        fromView.alpha = 1
        
        //load nib
        var cellNib = UINib(nibName: CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CellIdentifiers.loadingCell)
        
        cellNib = UINib(nibName: CellIdentifiers.loadingGridCell, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: CellIdentifiers.loadingGridCell)
        
        //create URL request
//        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
//        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
//        let request = NSURLRequest(
//            URL: url!,
//            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
//            timeoutInterval: 10)
//
//        //configure session -> executed on main thread
//        let session = NSURLSession(
//            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
//            delegate: nil,
//            delegateQueue: NSOperationQueue.mainQueue()
//        )
//
//        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
//            if let data = dataOrNil {
//                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary{
//                    //print("Response: \(responseDictionary)")
//                    let resultArray = responseDictionary["results"] as! [NSDictionary]
//
//                    for result in resultArray{
//                        let movie = Movie()
//                        movie.title = result["title"] as! String
//                        movie.posterPath = result["poster_path"] as! String
//                        movie.adult = result["adult"] as! Bool
//                        movie.overview = result["overview"] as! String
//                        movie.originalLanguge = result["original_language"] as! String
//                        movie.voteCount = result["vote_count"] as! Int
//                        movie.voteAverage = result["vote_average"] as! Double
//                        movie.releaseDate = result["release_date"] as! String
//
//                        self.movies.append(movie)
//                    }
//                    self.animate()
//                    self.isLoading = false
//                    self.tableView.reloadData()
//                    self.collectionView.reloadData()
//                }
//            } else {
//                self.showNetworkError()
//            }
//        })
//        task.resume()
        
        //apply pull to refresh to the tableview
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        collectionView.insertSubview(refreshControl, at: 0)
        
        //add search bar to navigation bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for movie name..."
        searchController.searchBar.prompt = "coderschool.vn"
        searchController.searchBar.tintColor = .lightGray
        searchController.searchBar.searchBarStyle = .minimal
        
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        //customize buttons
        let switchButton = UIButton()
        switchButton.setImage(UIImage(named: "grid"), for: .normal)
        switchButton.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        switchButton.layer.cornerRadius = 4
        switchButton.layer.borderColor =  UIColor.lightGray.cgColor
        switchButton.layer.borderWidth = 1.0
        switchButton.layer.masksToBounds = true
        switchButton.layer.backgroundColor = UIColor.clear.cgColor
        switchButton.addTarget(self, action: #selector(switchView(_:)), for: .touchUpInside)
        switchViewButton.customView = switchButton
        
        //customize table view
        tableView.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        tableView.separatorColor = .darkGray
        tableView.indicatorStyle = .white
        
        //create splash animation
        //create mask
        self.mask = CALayer()
        self.mask!.contents = UIImage(named: "bat")!.cgImage //twitter logo mask
        self.mask!.contentsGravity = kCAGravityResizeAspect //allow image to fit within the layer bounds without distoring the ratio
        self.mask!.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.mask!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mask!.position = CGPoint(x: view.frame.size.width/2, y: 170)
        
        //add logo as mask to view
        fromView.layer.mask = mask
        
        //twitter brand colors
        self.view.backgroundColor = .lightGray
        
        //animate()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //check if user uses app for the first time
        let defaults = UserDefaults.standard
        let hasViewWalkthrough = defaults.bool(forKey: "hasViewWalkthrough")

        if hasViewWalkthrough {
            return
        }
        
        //if firstTime, walk them thru
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? WalkthroughPageViewController{
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
//MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading{
            return 1
        } else if searchController.isActive {
            return searchResults.count
        }
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoading{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.loadingCell, for: indexPath)
            let spiner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spiner.startAnimating()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.movieCell, for: indexPath) as! MovieCell
        
            let movie = searchController.isActive ? searchResults[indexPath.row] : movies[indexPath.row]

            cell.titleLabel.text = movie.title.capitalized
            
            cell.voteCountLabel.text = "/" + "\(movie.voteCount)" + " votes"
            
            cell.ratingLabel.text = String(format: "%.1f", movie.voteAverage)
            if movie.voteAverage >= 5.0{
                cell.ratingLabel.backgroundColor = UIColor(red: 164.0/255.0, green: 198.0/255.0, blue: 57.0/255.0, alpha: 1.0)
            } else{
                cell.ratingLabel.backgroundColor = UIColor.red
            }
            
            cell.dateLabel.text = movie.releaseDate
        
            //made the poster image fade in
//            let fullPosterUrl = baseUrl + movie.posterPath
//            let imageRequest = NSURLRequest(URL: NSURL(string: fullPosterUrl)!)
//            cell.posterImageView.setImageWithURLRequest(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
//                if imageResponse != nil{
//                    cell.posterImageView.alpha = 0.0
//                    cell.posterImageView.image = image
//                    UIView.animateWithDuration(0.3, animations: { _ -> Void in
//                        cell.posterImageView.alpha = 1.0
//                    })
//                } else{
//                    cell.posterImageView.image = image
//                }
//                }, failure: { (imageRequest, imageResponse, image) -> Void in
//                    
//            })
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if isLoading{
            return nil
        }
        
        return indexPath
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        if isLoading{
            return 568
        }
        return 116
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetailFromRow"{
            let controller = segue.destination as! MovieDetailViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                controller.movie = searchController.isActive ? searchResults[indexPath.row] : movies[indexPath.row]
                controller.hidesBottomBarWhenPushed = true
            }
        } else if segue.identifier == "MovieDetailFromGrid"{
            let controller = segue.destination as! MovieDetailViewController
            
            if let indexPaths = collectionView.indexPathsForSelectedItems {
                if let indexPath = indexPaths.first {
                    controller.movie = searchController.isActive ? searchResults[indexPath.row] : movies[indexPath.row]
                    controller.hidesBottomBarWhenPushed = true
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func switchView(_ sender: UIBarButtonItem){
        let fromView = inTableView ? tableView : collectionView
        let toView = inTableView ? collectionView : tableView
        self.switchViewButton.image = inTableView ? UIImage(named: "grid") : UIImage(named: "table")
        
        UIView.animate(withDuration: 0.5, animations: {
            fromView.alpha = 0
            toView.alpha = 1
            }, completion: { _ in
                self.inTableView = !self.inTableView
                print(self.inTableView)
                let defaults = UserDefaults.standard
                defaults.set(self.inTableView, forKey: "switchView")
        })
    }
    
    //MARK: - Helpers
    struct CellIdentifiers {
        static let movieCell = "MovieCell"
        static let loadingCell = "LoadingCell"
        static let movieGridCell = "GridCell"
        static let loadingGridCell = "LoadingGridCell"
    }
    
    //present this func when there is an netwrk error while loading tableview
    func showNetworkError(){
        let alert = UIAlertController(title: "Whoops", message: "Network Error. Plese check your network connection", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        //create URL request
//        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
//        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
//        let request = NSURLRequest(
//            URL: url!,
//            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
//            timeoutInterval: 10)
//
//        //configure session -> executed on main thread
//        let session = NSURLSession(
//            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
//            delegate: nil,
//            delegateQueue: NSOperationQueue.mainQueue()
//        )
//
//        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
//            if let data = dataOrNil {
//                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary{
//                    let resultArray = responseDictionary["results"] as! [NSDictionary]
//
//                    for result in resultArray{
//                        let movie = Movie()
//                        movie.title = result["title"] as! String
//                        movie.posterPath = result["poster_path"] as! String
//                        movie.adult = result["adult"] as! Bool
//                        movie.overview = result["overview"] as! String
//                        movie.originalLanguge = result["original_language"] as! String
//                        movie.voteCount = result["vote_count"] as! Int
//                        movie.voteAverage = result["vote_average"] as! Double
//                        movie.releaseDate = result["release_date"] as! String
//
//                        self.movies.append(movie)
//                    }
//
//                    self.tableView.reloadData()
//                    self.collectionView.reloadData()
//                    refreshControl.endRefreshing()
//                }
//            } else {
//                self.showNetworkError()
//                refreshControl.endRefreshing()
//            }
//        })
//        task.resume()
    }
    
    //create an array which store all the searched movies
    func searchMovie(searchText: String){
        searchResults = movies.filter({ (movie: Movie) -> Bool in
            let nameMatch = movie.title.rangeOfCharacter(from: CharacterSet(charactersIn: searchText), options: .caseInsensitive, range: nil)
            return (nameMatch != nil)
        })
    }
    
    //MARK: - Animations
    func animate() {
        
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self
//        keyFrameAnimation.duration = 0.5
//        keyFrameAnimation.beginTime = CACurrentMediaTime() + 1 //add delay of 1 second
//
//        //start animation
//        let initialBounds = NSValue(CGRect: mask!.bounds)
//
//        //bounce/zooming effect
//        let middleBounds = NSValue(CGRect: CGRect(x: 0, y: 0, width: 90, height: 90))
//        let finalBounds = NSValue(CGRect: CGRect(x: 0, y: 0, width: 2000, height: 2000))
//
//        //add NSValues and keytimes
//        keyFrameAnimation.values = [initialBounds, middleBounds, finalBounds]
//        keyFrameAnimation.keyTimes = [0.0, 0.3, 1]
//
//
//        //animation timing functions
//        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
//
//        //add animation
//        self.mask?.add(keyFrameAnimation, forKey: "bounds")
    }
}

extension MovieListViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //removes mask when animation completes
        let defauls = UserDefaults.standard
        inTableView = defauls.bool(forKey: "switchView")
        let fromView = inTableView ? tableView : collectionView
        
        fromView.layer.mask = nil
        //comment out this function and see what happen
    }
}

//MARK: - EXTENSION: UISearchResultsUpdating
extension MovieListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            searchMovie(searchText: searchText)
            tableView.reloadData()
            collectionView.reloadData()
        }
    }
}

//MARK: - EXTENSION: UICollectionViewDataSource, UICollectionViewDelegate

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading{
            return 1
        } else if searchController.isActive {
            return searchResults.count
        }
        
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoading{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.loadingGridCell, for: indexPath)
            let spiner = cell.viewWithTag(101) as! UIActivityIndicatorView
            spiner.startAnimating()
            return cell
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.movieGridCell, for: indexPath) as! MovieGridCell
        
            let movie = searchController.isActive ? searchResults[indexPath.row] : movies[indexPath.row]
        
            cell.titleLabel.text = movie.title.capitalized
        
            //made the poster image fade in
//            let fullPosterUrl = baseUrl + movie.posterPath
//            let imageRequest = NSURLRequest(URL: NSURL(string: fullPosterUrl)!)
//            cell.posterImageView.setImageWithURLRequest(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
//                if imageResponse != nil{
//                    cell.posterImageView.alpha = 0.0
//                    cell.posterImageView.image = image
//                    UIView.animateWithDuration(0.3, animations: { _ -> Void in
//                        cell.posterImageView.alpha = 1.0
//                    })
//                } else{
//                    cell.posterImageView.image = image
//                }
//            }, failure: { (imageRequest, imageResponse, image) -> Void in})

        return cell
        }
    }
    
}
