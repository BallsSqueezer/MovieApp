//
//  WalkthroughPageViewController.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 7/10/16.
//  Copyright © 2016 Hien Tran. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    //MARK: - Outlets and variables
    var pageHeadings = ["Personalize", "Discover", "Enjoyable", "Happy Marking"]
    var pageImages = ["walkthru1", "walkthru4", "walkthru5", "coder_school"]
    var pageContent = ["We have everything that suits your style",
                       "Searching for your favourite movies can't never be easier",
                       "Enjoy you favourite movies with friends and family",
                       "Thank you for marking my assignment"]

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        if let startingViewController = viewControllerAtIndex(0){
            setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        
        return viewControllerAtIndex(index)
    }

    
    
    //MARK: - Helpers
    func viewControllerAtIndex(index: Int) -> WalkthroughContentViewController?{
        if index == NSNotFound || index < 0 || index >= pageHeadings.count{
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        if let pageContentViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughContentViewController") as? WalkthroughContentViewController{
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.content = pageContent[index]
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
    
    func goNext(index: Int){
        if let nextViewController = viewControllerAtIndex(index + 1){
            setViewControllers([nextViewController], direction: .Forward, animated: true, completion: nil)
        }
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
