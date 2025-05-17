//
//  LatestMovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import Foundation
import SwiftUI

/// A collection view cell that displays movie information using `MovieInfoView`.
class LatestMovieCollectionViewCell: UICollectionViewCell {
    private var movieInfoView: MovieInfoView?

    /// Prepares the cell for reuse by removing the existing movie view.
    override func prepareForReuse() {
        movieInfoView?.removeFromSuperview()
        movieInfoView = nil
        super.prepareForReuse()
    }

    /// Configures the cell with a movie model.
    func configure(with movieModel: MovieInfoModel) {
        backgroundColor = .clear
        setupMovieInfoView(with: movieModel)
    }

    /// Adds and lays out the movie info view inside the cell.
    private func setupMovieInfoView(with movieModel: MovieInfoModel) {
        let view = MovieInfoView(frame: .zero, movieModel: movieModel)
        view.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])

        movieInfoView = view
    }
}
