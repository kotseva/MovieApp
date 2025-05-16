//
//  MovieInfoModel.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import Foundation

class MovieInfoModel: Codable {
    
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Float
    let popularity: Float
    let id: Int
    let title: String
    let overview: String
    
}
