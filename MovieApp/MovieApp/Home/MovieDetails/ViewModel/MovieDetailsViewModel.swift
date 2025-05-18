//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Angela Koceva on 18.5.25.
//

import Foundation

class MovieDetailsViewData {
    var movieInfoModel: MovieInfoModel
    
    init(_ movieInfoModel: MovieInfoModel) {
        self.movieInfoModel = movieInfoModel
    }
}

class MovieDetailsViewModel {
    
    weak var viewController: MovieDetailsViewController?
    private var dataModel: MovieDetailsViewData
    
    init(_ movieInfoModel: MovieInfoModel) {
        dataModel = MovieDetailsViewData(movieInfoModel)
    }
    
    func movieInfoModel() -> MovieInfoModel {
        return dataModel.movieInfoModel
    }
    
    func movieTitle() -> String {
        return dataModel.movieInfoModel.title
    }
}
