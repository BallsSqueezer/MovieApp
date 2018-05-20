//
//  MovieCell.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 7/6/16.
//  Copyright © 2016 Hien Tran. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell, Reusable {
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 20) ?? UIFont.boldSystemFont(ofSize: 26)
        label.textColor = UIColor(hex: "#FFFFFF") ?? .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "TimesNewRomanPSMT", size: 14) ?? UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#FFFFFF") ?? .black
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial-BoldMT", size: 12) ?? UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(hex: "#FFFFFF") ?? .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial-BoldMT", size: 12) ?? UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(hex: "#FFFFFF") ?? .black
        label.textAlignment = .center //.left
        label.numberOfLines = 0
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var voteCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial-BoldMT", size: 12) ?? UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(hex: "#FFFFFF") ?? .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .darkGray
        
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(voteCountLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            posterImageView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor),
            // Comment out these two lines for demo
            posterImageView.heightAnchor.constraint(equalToConstant: 100),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 0.7),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            overviewLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            overviewLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 8),
            ratingLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            ratingLabel.widthAnchor.constraint(equalToConstant: 50),
            
            voteCountLabel.lastBaselineAnchor.constraint(equalTo: ratingLabel.lastBaselineAnchor),
            voteCountLabel.leftAnchor.constraint(equalTo: ratingLabel.rightAnchor, constant: 8),
            
            // Toggle these two lines for demo
//            voteCountLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            voteCountLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.rightAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8),
            dateLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            dateLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
