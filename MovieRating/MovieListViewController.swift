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

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        isLoading = true
        
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        
        //display tableview/gridview based on last time
        let defauls = NSUserDefaults.standardUserDefaults()
        inTableView = defauls.boolForKey("switchView")
        
        let fromView = inTableView ? tableView : collectionView
        let toView = inTableView ? collectionView : tableView
        toView.alpha = 0
        fromView.alpha = 1
        
        //load nib
        var cellNib = UINib(nibName: CellIdentifiers.loadingCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: CellIdentifiers.loadingCell)
        
        cellNib = UINib(nibName: CellIdentifiers.loadingGridCell, bundle: nil)
        collectionView.registerNib(cellNib, forCellWithReuseIdentifier: CellIdentifiers.loadingGridCell)
        
        //create URL request
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        //configure session -> executed on main thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary{
                    //print("Response: \(responseDictionary)")
                    let resultArray = responseDictionary["results"] as! [NSDictionary]
                    
                    for result in resultArray{
                        let movie = Movie()
                        movie.title = result["title"] as! String
                        movie.posterPath = result["poster_path"] as! String
                        movie.adult = result["adult"] as! Bool
                        movie.overview = result["overview"] as! String
                        movie.originalLanguge = result["original_language"] as! String
                        movie.voteCount = result["vote_count"] as! Int
                        movie.voteAverage = result["vote_average"] as! Double
                        movie.releaseDate = result["release_date"] as! String
                        
                        self.movies.append(movie)
                    }
                    self.isLoading = false
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
            } else {
                self.showNetworkError()
            }
        })
        task.resume()        
        
        //apply pull to refresh to the tableview
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        //add search bar to navigation bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for movie name..."
        searchController.searchBar.prompt = "coderschool.vn"
        searchController.searchBar.tintColor = UIColor.lightGrayColor()
        searchController.searchBar.searchBarStyle = .Minimal
        
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        //customize buttons
        let switchButton = UIButton()
        switchButton.setImage(UIImage(named: "grid"), forState: .Normal)
        switchButton.frame = CGRectMake(0, 0, 40, 30)
        switchButton.layer.cornerRadius = 4
        switchButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        switchButton.layer.borderWidth = 1.0
        switchButton.layer.masksToBounds = true
        switchButton.layer.backgroundColor = UIColor.clearColor().CGColor
        switchButton.addTarget(self, action: #selector(switchView(_:)), forControlEvents: .TouchUpInside)
        switchViewButton.customView = switchButton
        
        //customize table view
        tableView.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        tableView.separatorColor = UIColor.darkGrayColor()
        tableView.indicatorStyle = .White
        
        //create splash animation
        //create mask
        self.mask = CALayer()
        self.mask!.contents = UIImage(named: "bat")!.CGImage //twitter logo mask
        self.mask!.contentsGravity = kCAGravityResizeAspect //allow image to fit within the layer bounds without distoring the ratio
        self.mask!.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.mask!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mask!.position = CGPoint(x: view.frame.size.width/2, y: 170)
        
        //add logo as mask to view
        fromView.layer.mask = mask
        
        //twitter brand colors
        self.view.backgroundColor = UIColor.darkGrayColor()
        
        animate()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //check if user uses app for the first time
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewWalkthrough = defaults.boolForKey("hasViewWalkthrough")

        if hasViewWalkthrough {
            return
        }
        
        //if firstTime, walk them thru
        if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughController") as? WalkthroughPageViewController{
            presentViewController(pageViewController, animated: true, completion: nil)
        }
    }
    
//MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading{
            return 1
        } else if searchController.active {
            return searchResults.count
        }
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if isLoading{
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.loadingCell, forIndexPath: indexPath)
            let spiner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spiner.startAnimating()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.movieCell, forIndexPath: indexPath) as! MovieCell
        
            let movie = searchController.active ? searchResults[indexPath.row] : movies[indexPath.row]

            cell.titleLabel.text = movie.title.capitalizedString
            
            cell.voteCountLabel.text = "/" + "\(movie.voteCount)" + " votes"
            
            cell.ratingLabel.text = String(format: "%.1f", movie.voteAverage)
            if movie.voteAverage >= 5.0{
                cell.ratingLabel.backgroundColor = UIColor(red: 164.0/255.0, green: 198.0/255.0, blue: 57.0/255.0, alpha: 1.0)
            } else{
                cell.ratingLabel.backgroundColor = UIColor.redColor()
            }
            
            cell.dateLabel.text = movie.releaseDate
        
            //made the poster image fade in
            let fullPosterUrl = baseUrl + movie.posterPath
            let imageRequest = NSURLRequest(URL: NSURL(string: fullPosterUrl)!)
            cell.posterImageView.setImageWithURLRequest(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                if imageResponse != nil{
                    cell.posterImageView.alpha = 0.0
                    cell.posterImageView.image = image
                    UIView.animateWithDuration(0.3, animations: { _ -> Void in
                        cell.posterImageView.alpha = 1.0
                    })
                } else{
                    cell.posterImageView.image = image
                }
                }, failure: { (imageRequest, imageResponse, image) -> Void in
                    
            })
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if isLoading{
            return nil
        }
        
        return indexPath
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isLoading{
            return 568
        }
        return 116
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MovieDetailFromRow"{
            let controller = segue.destinationViewController as! MovieDetailViewController
        
            if let indexPath = tableView.indexPathForSelectedRow{
                controller.movie = searchController.active ? searchResults[indexPath.row] : movies[indexPath.row]
                controller.hidesBottomBarWhenPushed = true
            }
        } else if segue.identifier == "MovieDetailFromGrid"{
            let controller = segue.destinationViewController as! MovieDetailViewController
            
            if let indexPaths = collectionView.indexPathsForSelectedItems(){
                if let indexPath = indexPaths.first{
                    controller.movie = searchController.active ? searchResults[indexPath.row] : movies[indexPath.row]
                    controller.hidesBottomBarWhenPushed = true
                }
            }
        }
    }
    
    // MARK: - Actions
    
    func switchView(sender: UIBarButtonItem){
        let fromView = inTableView ? tableView : collectionView
        let toView = inTableView ? collectionView : tableView
        self.switchViewButton.image = inTableView ? UIImage(named: "grid") : UIImage(named: "table")
        
        UIView.animateWithDuration(0.5, animations: { _ in
            fromView.alpha = 0
            toView.alpha = 1
            }, completion: { _ in
                self.inTableView = !self.inTableView
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(self.inTableView, forKey: "switchView")
                self.switchViewButton.image = self.inTableView == true ? UIImage(named: "grid") : UIImage(named: "table")
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
        let alert = UIAlertController(title: "Whoops", message: "Network Error. Plese check your network connection", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //
    func refreshControlAction(refreshControl: UIRefreshControl){
        //create URL request
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        //configure session -> executed on main thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary{
                    let resultArray = responseDictionary["results"] as! [NSDictionary]
                    
                    for result in resultArray{
                        let movie = Movie()
                        movie.title = result["title"] as! String
                        movie.posterPath = result["poster_path"] as! String
                        movie.adult = result["adult"] as! Bool
                        movie.overview = result["overview"] as! String
                        movie.originalLanguge = result["original_language"] as! String
                        movie.voteCount = result["vote_count"] as! Int
                        movie.voteAverage = result["vote_average"] as! Double
                        movie.releaseDate = result["release_date"] as! String
                        
                        self.movies.append(movie)
                    }

                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    refreshControl.endRefreshing()
                }
            } else {
                self.showNetworkError()
                refreshControl.endRefreshing()
            }
        })
        task.resume()
    }
    
    //create an array which store all the searched movies
    func searchMovie(searchText: String){
        searchResults = movies.filter({ (movie: Movie) -> Bool in
            let nameMatch = movie.title.rangeOfString(searchText, options: .CaseInsensitiveSearch)
            return (nameMatch != nil)
        })
    }
    
    //MARK: - Animations
    func animate() {
        
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self
        keyFrameAnimation.duration = 1.5
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 1 //add delay of 1 second
        
        //start animation
        let initialBounds = NSValue(CGRect: mask!.bounds)
        
        
        //bounce/zooming effect
        let middleBounds = NSValue(CGRect: CGRect(x: 0, y: 0, width: 90, height: 90))
        let finalBounds = NSValue(CGRect: CGRect(x: 0, y: 0, width: 2000, height: 2000))
        
        //add NSValues and keytimes
        keyFrameAnimation.values = [initialBounds, middleBounds, finalBounds]
        keyFrameAnimation.keyTimes = [0.0, 0.3, 1]
        
        
        //animation timing functions
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        
        //add animation
        self.mask?.addAnimation(keyFrameAnimation, forKey: "bounds")
        
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        //removes mask when animation completes
        let defauls = NSUserDefaults.standardUserDefaults()
        inTableView = defauls.boolForKey("switchView")
        let fromView = inTableView ? tableView : collectionView
        
        fromView.layer.mask = nil
        //comment out this function and see what happen
    }
}

//MARK: - EXTENSION: UISearchResultsUpdating
extension MovieListViewController: UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            searchMovie(searchText)
            tableView.reloadData()
            collectionView.reloadData()
        }
    }
}

//MARK: - EXTENSION: UICollectionViewDataSource, UICollectionViewDelegate

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading{
            return 1
        } else if searchController.active {
            return searchResults.count
        }
        
        return movies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if isLoading{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifiers.loadingGridCell, forIndexPath: indexPath)
            let spiner = cell.viewWithTag(101) as! UIActivityIndicatorView
            spiner.startAnimating()
            return cell
        } else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifiers.movieGridCell, forIndexPath: indexPath) as! MovieGridCell
        
            let movie = searchController.active ? searchResults[indexPath.row] : movies[indexPath.row]
        
            cell.titleLabel.text = movie.title.capitalizedString
        
            //made the poster image fade in
            let fullPosterUrl = baseUrl + movie.posterPath
            let imageRequest = NSURLRequest(URL: NSURL(string: fullPosterUrl)!)
            cell.posterImageView.setImageWithURLRequest(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                if imageResponse != nil{
                    cell.posterImageView.alpha = 0.0
                    cell.posterImageView.image = image
                    UIView.animateWithDuration(0.3, animations: { _ -> Void in
                        cell.posterImageView.alpha = 1.0
                    })
                } else{
                    cell.posterImageView.image = image
                }
            }, failure: { (imageRequest, imageResponse, image) -> Void in})

        return cell
        }
    }
    
}
