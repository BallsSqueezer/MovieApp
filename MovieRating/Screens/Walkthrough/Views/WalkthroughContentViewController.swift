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
        label.font = UIFont(name: "ArialMT", size: 14) ?? UIFont.systemFont(ofSize: 14)
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
    
    public var walkthroughContent: WalkthroughContent? {
        didSet {
            guard let content = walkthroughContent else { return }
            
            headingLabel.text = content.heading
            contentLabel.text = content.content
            
            contentImageView.image = UIImage(named: content.imageFile, in: targetBundle, compatibleWith: nil)
        }
    }
    
    private var _index: Int?
    
    var index: Int? {
        return _index
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
    
    func setIndex(_ index: Int) {
        _index = index
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
            contentImageView.widthAnchor.constraint(equalToConstant: 270),
            contentImageView.heightAnchor.constraint(equalTo: contentImageView.widthAnchor, multiplier: CGFloat(16)/CGFloat(9)),
            
            contentLabel.topAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: 20),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10),
            contentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentLabel.leftAnchor.constraint(lessThanOrEqualTo: view.leftAnchor, constant: 30)
        ])
    }
}
