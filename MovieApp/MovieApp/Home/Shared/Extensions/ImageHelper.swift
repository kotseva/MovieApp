//
//  ImageHelper.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import SwiftUI
import Kingfisher

class ImageHelper {
    @MainActor static func setupImageForView(_ imageView: UIImageView, imagePath: String?) {
        guard let imagePath = imagePath, let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)") else {
            imageView.image = UIImage(named: "film")
            return
        }

        imageView.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "film"),
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        )
    }
}
