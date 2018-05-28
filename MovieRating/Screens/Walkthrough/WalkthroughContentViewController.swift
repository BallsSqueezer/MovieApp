//
//  WalkthroughContentViewController.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 7/10/16.
//  Copyright © 2016 Hien Tran. All rights reserved.
//

import UIKit

public class WalkthroughContentViewController: UIViewController {
    
    private lazy var headingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 20) ?? UIFont.boldSystemFont(ofSize: 26)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "TimesNewRomanPSMT", size: 14) ?? UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.tintColor = UIColor(r: 170, g: 170, b: 170, a: 1)
        control.currentPageIndicatorTintColor = UIColor(r: 85, g: 85, b: 85, a: 85)
        return control
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(nextButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    public var walkthroughContent: WalkthroughContent? {
        didSet {
            guard let content = walkthroughContent else { return }
            
            pageControl.currentPage = content.index
            headingLabel.text = content.heading
            contentLabel.text = content.content
            
            let bundle = Bundle(for: WalkthroughContentViewController.self)
            contentImageView.image = UIImage(named: content.imageFile, in: bundle, compatibleWith: nil)
            
            //set the title of nextButton depeding on the current page
            switch content.index {
            case 0...2:
                nextButton.setTitle("NEXT", for: .normal)
            case 3:
                nextButton.setTitle("", for: .normal)
                nextButton.setImage(UIImage(named: "CloseButton" ), for: .normal)
            default:
                break
            }
        }
    }
    
    var index: Int? {
        return walkthroughContent?.index
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(headingLabel)
        view.addSubview(contentImageView)
        view.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headingLabel.leftAnchor.constraint(lessThanOrEqualTo: view.leftAnchor, constant: 30),
            
            contentImageView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 20),
            contentImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentImageView.widthAnchor.constraint(equalToConstant: 300),
            contentImageView.heightAnchor.constraint(equalTo: contentImageView.widthAnchor, multiplier: CGFloat(16)/CGFloat(9)),
            
            contentLabel.topAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: 20),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10),
            contentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentLabel.leftAnchor.constraint(lessThanOrEqualTo: view.leftAnchor, constant: 30),
        ])
        
    }
    
    //MARK: - Actions
    @IBAction func nextButtonTapped(sender: UIButton){
//        switch index {
//        case 0...2:
//            let pageViewController = parent as! WalkthroughPageViewController
//            pageViewController.goNext(index: index)
//        case 3:
//            //store the bool value that indicate user uses this for the first time
//            let defaults = UserDefaults.standard
//            defaults.set(true, forKey: "hasViewWalkthrough")
//
//            dismiss(animated: true, completion: nil)
//        default:
//            break
//        }
    }
}
