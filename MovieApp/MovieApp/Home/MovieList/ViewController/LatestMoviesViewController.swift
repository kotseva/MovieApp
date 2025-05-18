//
//  LatestMoviesViewController.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import Foundation
import SwiftUI

class LatestMoviesViewController: MovieListViewController
{
    init() {
        let viewModel = MovieListViewModel()
        super.init(viewModel: viewModel)
        viewModel.viewController = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
