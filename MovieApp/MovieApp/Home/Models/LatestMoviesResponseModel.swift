//
//  LatestMoviesResponseModel.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import Foundation

class LatestMoviesResponseModel: Decodable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [MovieInfoModel]
}
