//
//  HomeTabBarController.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import Foundation
import SwiftUI

class HomeTabBarController: UITabBarController {
    
    let appearance = UITabBarAppearance()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let latestMoviesVC = LatestMoviesViewController()
        
        let latestMoviesTabBarItem = UITabBarItem(
            title: "Latest Movies",
            image: UIImage(systemName: "play.fill"),
            tag: 0
        )
        
        latestMoviesVC.tabBarItem = latestMoviesTabBarItem
        latestMoviesVC.tabBarItem.standardAppearance = appearance
        
        //TODO: Add the tabbar item
        self.viewControllers = [latestMoviesVC]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
