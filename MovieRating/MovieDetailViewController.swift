//
//  MovieDetailViewController.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 7/7/16.
//  Copyright © 2016 Hien Tran. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailViewController: UIViewController {

    //MARK: - Outlets and Variables
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var movieInfoView: UIView!
    
    @IBOutlet weak var ratingIndicatorImageView: UIImageView!
    var movie: Movie!
    
    //MARK: - UIViewControlelr
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = movie.title.capitalizedString
        
        
        //set up outlets
        let overview = movie.overview
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        ratingLabel.text = String(format: "%.1f", movie.voteAverage)
        titleLabel.text = movie.title.capitalizedString
        ratingIndicatorImageView.image = movie.voteAverage >= 5.0 ? UIImage(named: "banner_green") : UIImage(named: "banner_red")
        
        //
        view.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        movieInfoView.layer.cornerRadius = 10
        
        //load the low resolution image first then load the high resolution image when available
        let highResolutionBaseUrl = "https://image.tmdb.org/t/p/original"
        let highResPosterUrl = highResolutionBaseUrl + movie.posterPath
        let highResImageRequest = NSURLRequest(URL: NSURL(string: highResPosterUrl)!)
        
        let lowResolutionBaseUrl = "https://image.tmdb.org/t/p/w45"
        let lowResPosterUrl = lowResolutionBaseUrl + movie.posterPath
        let lowResImageRequest = NSURLRequest(URL: NSURL(string: lowResPosterUrl)!)
        
        posterImageView.setImageWithURLRequest(lowResImageRequest, placeholderImage: nil, success: { (lowResImageRequest, lowResImageResponse, lowResImage) in
            self.posterImageView.alpha = 0.0
            self.posterImageView.image = lowResImage
            UIView.animateWithDuration(0.3, animations: { _ -> Void in
                self.posterImageView.alpha = 1.0
            }, completion: { sucess in
                self.posterImageView.setImageWithURLRequest(highResImageRequest, placeholderImage: lowResImage, success: { (highResImageRequest, highResImageResponse, highResImage) in
                    self.posterImageView.image = highResImage
                }, failure: { (request, response, image) in
                    
                })
            })
        }, failure: { (request, response, image) in
        })
        
        //set up scrollable area for scrollView
        scrollView.contentSize = CGSize(width: view.bounds.size.width, height: movieInfoView.frame.origin.y + movieInfoView.frame.size.height + overviewLabel.frame.size.height + 20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
