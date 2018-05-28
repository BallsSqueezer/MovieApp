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
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isUserInteractionEnabled = false
        control.pageIndicatorTintColor = UIColor(r: 170, g: 170, b: 170, a: 1)
        control.currentPageIndicatorTintColor = UIColor(r: 85, g: 85, b: 85, a: 85)
        return control
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r: 170, g: 170, b: 170, a: 1), for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
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
        
        pageControl.numberOfPages = viewModel.numberOfItems
        
        updateControl()
        addSubviews()
        
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
    
    private func addSubviews() {
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextButton.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
    
    private func updateControl() {
        pageControl.currentPage = viewModel.currentIndex
        
        let title = viewModel.isInLastIndex
            ? "DONE"
            : "NEXT"
        nextButton.setTitle(title, for: .normal)
    }
    
    @objc private func nextButtonTapped(sender: UIButton) {
        if viewModel.isInLastIndex {
            dismiss(animated: true) {
                UserDefaults.standard.set(true, forKey: UserDefault.Walkthrough.didWatchWalkthrough)
            }
        } else {
            let nextIndex = viewModel.currentIndex + 1
            guard let nextWalkthroughViewController = viewController(at: nextIndex) else { return }
            setViewControllers([nextWalkthroughViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            
            viewModel.setCurrentIndex(to: nextIndex)
            updateControl()
        }
    }
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
            updateControl()
        } else {
            guard
                let viewController = previousViewControllers.first as? WalkthroughContentViewController,
                let index = viewController.index
            else { return }
            
            viewModel.setCurrentIndex(to: index)
        }
    }
}
