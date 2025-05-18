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
    
    var formattedReleaseDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: releaseDate) {
            formatter.dateFormat = "d MMM yyyy"
            return formatter.string(from: date)
        } else {
            return releaseDate
        }
    }
}
