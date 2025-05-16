//
//  HomeTabBarController.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import Foundation
import CoreData
import SwiftUI

class HomeTabBarController: UITabBarController {
    init(_ viewContext: NSManagedObjectContext) {
        super.init(nibName: nil, bundle: nil)
        
        let latestMoviesVC = LatestMoviesViewController(viewContext)

        let latestMoviesTabBarItem = UITabBarItem(title: "Latest Movies",
                                                  image: UIImage(systemName: "play.fill"),
                                                  tag: 0)

        latestMoviesVC.tabBarItem = latestMoviesTabBarItem
        self.viewControllers = [latestMoviesVC]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
