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
        
        //TODO: - Remove the tabbar and reorganize the constraints
        latestMoviesVC.tabBarItem.standardAppearance = appearance
        
        self.viewControllers = [latestMoviesVC]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
