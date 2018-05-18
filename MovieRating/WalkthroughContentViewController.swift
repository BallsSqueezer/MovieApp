//
//  WalkthroughContentViewController.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 7/10/16.
//  Copyright © 2016 Hien Tran. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    
    @IBOutlet var headingLabel:UILabel!
    @IBOutlet var contentLabel:UILabel!
    @IBOutlet var contentImageView:UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.currentPage = index

        headingLabel.text = heading
        //headingLabel.sizeToFit()
        headingLabel.textAlignment = .center
        contentLabel.text = content
        contentLabel.textAlignment = .center
        contentImageView.image = UIImage(named: imageFile)
        
        //set the title of nextButton depeding on the current page
        switch index {
        case 0...2:
            nextButton.setTitle("NEXT", for: .normal)
        case 3:
            nextButton.setTitle("", for: .normal)
            nextButton.setImage(UIImage(named: "CloseButton" ), for: .normal)
        default:
            break
        }
    }
    
    
    //MARK: - Actions
    @IBAction func nextButtonTapped(sender: UIButton){
        switch index {
        case 0...2:
            let pageViewController = parent as! WalkthroughPageViewController
            pageViewController.goNext(index: index)
        case 3:
            //store the bool value that indicate user uses this for the first time
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "hasViewWalkthrough")
            
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Helpers
    

}
