//
//  MovieDetailViewController.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 23/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//

import UIKit
import AFNetworking

final public class MovieDetailViewController: UIViewController {
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "TimesNewRomanPSMT", size: 17) ?? UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(hex: "#FFFFFF") ?? .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial-BoldMT", size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(hex: "#FFFFFF") ?? .black
        label.textAlignment = .center //.left
        label.numberOfLines = 0
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 20) ?? UIFont.boldSystemFont(ofSize: 26)
        label.textColor = UIColor(hex: "#FFFFFF") ?? .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var movieInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 85, g: 85, b: 85, a: 0.6)
        view.layer.cornerRadius = 7
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var ratingIndicatorImageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    public var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            
            navigationItem.title = movie.title?.capitalized
            titleLabel.text = movie.title?.capitalized
            overviewLabel.text = movie.overview
            ratingLabel.text = String(format: "%.1f", movie.voteAverage)
            
            let bundle = Bundle(for: MovieDetailViewController.self)
            ratingIndicatorImageView.image = movie.voteAverage >= 5.0
                ? UIImage(named: "banner_green", in: bundle, compatibleWith: nil)
                : UIImage(named: "banner_red", in: bundle, compatibleWith: nil)
            
            if let posterPath = movie.posterPath {
                loadImage(fromPath: posterPath)                
            }
        }
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        
        view.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(posterImageView)
        containerView.addSubview(movieInfoView)
        movieInfoView.addSubview(titleLabel)
        movieInfoView.addSubview(overviewLabel)
        movieInfoView.addSubview(ratingIndicatorImageView)
        movieInfoView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            posterImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            posterImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            posterImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            
            movieInfoView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -20),
            movieInfoView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            movieInfoView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            movieInfoView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: movieInfoView.topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: movieInfoView.leftAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(equalTo: movieInfoView.rightAnchor, constant: -8),
                
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            overviewLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            overviewLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
                
            ratingLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 8),
            ratingLabel.bottomAnchor.constraint(equalTo: movieInfoView.bottomAnchor, constant: -8),
            ratingLabel.leftAnchor.constraint(equalTo: ratingIndicatorImageView.rightAnchor, constant: 8),
                
            ratingIndicatorImageView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            ratingIndicatorImageView.leftAnchor.constraint(equalTo: movieInfoView.leftAnchor, constant: 8),
            ratingIndicatorImageView.heightAnchor.constraint(equalToConstant: 30),
            ratingIndicatorImageView.widthAnchor.constraint(equalTo: ratingIndicatorImageView.heightAnchor, multiplier: 1)
        ])
    }
    
    private func loadImage(fromPath path: String) {
        guard
            let highResolutionUrl = url(fromBaseUrl: "https://image.tmdb.org/t/p/original", path: path),
            let lowResolutionUrl = url(fromBaseUrl: "https://image.tmdb.org/t/p/w45", path: path)
        else {
            //set a height constraint for image
            return
        }
        
        let highResolutionRequest = URLRequest(url: highResolutionUrl)
        let lowResolutionRequest = URLRequest(url: lowResolutionUrl)
        
        loadImageWithRequest(lowResolutionRequest) {
            self.loadImageWithRequest(highResolutionRequest, completion: nil)
        }
    }
    
    private func loadImageWithRequest(_ request: URLRequest, completion: (() -> Void)?) {
        posterImageView.setImageWith(
            request,
            placeholderImage: nil,
            success: { [weak self] (_, _, image) in
                guard let `self` = self else { return }
                
                DispatchQueue.main.async {
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = image
                    
                    let hwRatio = image.size.height / image.size.width
                    
                    self.posterImageView.heightAnchor.constraint(equalTo: self.posterImageView.widthAnchor, multiplier: hwRatio).isActive = true
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.posterImageView.alpha = 1.0
                    }, completion: { success in
                        guard let `completion` = completion else { return }
                        completion()
                    })
                }
            },
            failure: nil
        )
    }
    
    private func url(fromBaseUrl baseUrl: String, path: String) -> URL? {
        return URL(string: baseUrl + path)
    }
}

