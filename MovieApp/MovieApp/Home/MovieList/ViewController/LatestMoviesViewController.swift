//
//  LatestMoviesViewController.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import Foundation
import CoreData
import SwiftUI

class LatestMoviesViewController: MovieListViewController
{
    init(context: NSManagedObjectContext) {
        let viewModel = MovieListViewModel(context: context)
        super.init(viewModel: viewModel)
        viewModel.viewController = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//class LatestMoviesViewController: MovieListViewController {
//    override init(_ managedObjectContext: NSManagedObjectContext) {
//        super.init(managedObjectContext)
//        viewModel = MovieListViewModel(context: managedObjectContext)
//        viewModel.viewController = self
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
