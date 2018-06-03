//
//  AppDelegate.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 7/6/16.
//  Copyright © 2016 Hien Tran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let nowPLayingMovieListViewController = MovieListViewController(path: "now_playing")
        let nowPlayingNavigationController = UINavigationController(rootViewController: nowPLayingMovieListViewController)
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "nowplaying")

        let topRatedMovieListViewController = MovieListViewController(path: "top_rated")
        let topRatedNavigationController = UINavigationController(rootViewController: topRatedMovieListViewController)
        topRatedNavigationController.tabBarItem.title = "Top Rated"
        topRatedNavigationController.tabBarItem.image = UIImage(named: "toprated")

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingNavigationController, topRatedNavigationController]

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        customizeApperance()
        
        return true
    }
    
    func customizeApperance(){
        //customize navigation bar
        UINavigationBar.appearance().barTintColor = .darkGray
        UINavigationBar.appearance().tintColor = .lightGray
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        //customize the status bar
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //customize the tab bar
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = UIColor.darkGray
    }
}

