//
//  HomeTabBarController.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import CoreData
import Foundation
import SwiftUI

class HomeTabBarController: UITabBarController {
    init(_ viewContext: NSManagedObjectContext) {
        super.init(nibName: nil, bundle: nil)

        let latestMoviesVC = LatestMoviesViewController(viewContext)

        let latestMoviesTabBarItem = UITabBarItem(
            title: "Latest Movies",
            image: UIImage(systemName: "play.fill"),
            tag: 0
        )

//        let favouritesTabBarItem = UITabBarItem(
//            title: "Favourites",
//            image: UIImage(systemName: "star.fill"),
//            tag: 1
//        )

        latestMoviesVC.tabBarItem = latestMoviesTabBarItem
//        latestMoviesVC.tabBarItem = favouritesTabBarItem
        
        //TODO: Add the tabbar item
        self.viewControllers = [latestMoviesVC]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
