//
//  LatestMovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import Foundation
import SwiftUI

class LatestMovieCollectionViewCell: UICollectionViewCell {
    private var movieInfoView: MovieInfoView?

    override func prepareForReuse() {
        movieInfoView?.removeFromSuperview()
        movieInfoView = nil
        super.prepareForReuse()
    }

    func configure(with movieModel: MovieInfoModel) {
        backgroundColor = .clear
        setupMovieInfoView(with: movieModel)
    }

    private func setupMovieInfoView(with movieModel: MovieInfoModel) {
        let view = MovieInfoView(frame: .zero, movieModel: movieModel)
        view.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            view.heightAnchor.constraint(equalToConstant: 100)
        ])

        movieInfoView = view
    }
}
