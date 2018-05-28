//
//  WalkthroughPageViewController.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 7/10/16.
//  Copyright © 2016 Hien Tran. All rights reserved.
//

import UIKit

public class WalkthroughPageViewController: UIPageViewController {
    
    private(set) var viewModel: WalkthroughViewModel
    
    public init(
        viewModel: WalkthroughViewModel,
        transitionStyle: UIPageViewControllerTransitionStyle,
        navigationOrientation: UIPageViewControllerNavigationOrientation,
        options: [String : Any]? = nil)
    {
        self.viewModel = viewModel
        super.init(transitionStyle: transitionStyle,
                   navigationOrientation: navigationOrientation,
                   options: options)
    }
    
    convenience public init(viewModel: WalkthroughViewModel) {
        self.init(viewModel: viewModel,
                  transitionStyle: .scroll,
                  navigationOrientation: .horizontal)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        if let startingViewController = viewController(at: viewModel.currentIndex) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    //MARK: - Helpers
    private func viewController(at index: Int) -> WalkthroughContentViewController? {
        guard
            index >= 0,
            index < viewModel.numberOfItems
        else { return nil }
        
        let content = viewModel.content(at: index)
        let walkthroughContentViewController = WalkthroughContentViewController()
        walkthroughContentViewController.walkthroughContent = content
            
        return walkthroughContentViewController
    }
    
//    func goNext(index: Int){
//        if let nextViewController = viewControllerAtIndex(index: index + 1) {
//            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
//        }
//    }
    
    var currentIndex = 0
}

extension WalkthroughPageViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return self.viewController(at: viewModel.currentIndex - 1)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        return self.viewController(at: viewModel.currentIndex + 1)
    }
}

extension WalkthroughPageViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard
            let viewController = pendingViewControllers.first as? WalkthroughContentViewController,
            let index = viewController.index
        else { return }
    
        viewModel.setCurrentIndex(to: index)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        //This is to handle the case when sometime user just swipes half way through and the page view controller doesn't actually transition to the next/previous page but bounces back the the current page
        //Check if the transition has completed. If YES, update the page controller. If NO, reverse the current index value that was set in pageViewController(_:willTransitionTo:) to its old value
        if completed {
            //Handle Page controller
//            guard let item = walkthroughItems[safe: currentIndex] else { return }
//                updatePageController(with: item)
        } else {
            guard
                let viewController = previousViewControllers.first as? WalkthroughContentViewController,
                let index = viewController.index
            else { return }
            
            viewModel.setCurrentIndex(to: index)
        }
    }
}
