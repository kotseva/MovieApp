//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Angela Koceva on 18.5.25.
//

import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: MovieInfoModel!
    private let backgroundColors = AppColors.background.self
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateContent()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        setupBackgroundAndNavigation()
        setupScrollView()
        setupImageView()
        setupMovieInfo()
        setupDescriptionSection()
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupBackgroundAndNavigation() {
        title = "Movie Details"
        view.backgroundColor = backgroundColors.primary
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupImageView() {
        ImageHelper.setupImageForView(imageView, imagePath: viewModel.posterPath)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
    }
    
    private func setupMovieInfo() {
        /// Title
        titleLabel.text = viewModel.title
        titleLabel.font = UIFont(name: Fonts.interBold, size: 24)
        titleLabel.numberOfLines = 0
        
        /// Rating
        ratingLabel.text = "⭐️ \(String(format: "%.1f", viewModel.voteAverage))"
        ratingLabel.font = UIFont(name: Fonts.interRegular, size: 16)
        ratingLabel.textColor = .gray
        
        /// Release Date
        releaseDate.text = "Release date:\n\(viewModel.formattedReleaseDate)"
        releaseDate.font = UIFont(name: Fonts.interRegular, size: 16)
        releaseDate.numberOfLines = 0
    }
    
    private func setupDescriptionSection() {
        /// Container styling
        descriptionView.layer.cornerRadius = 10
        stackView.spacing = 20
        stackView.backgroundColor = .clear
        
        /// Overview heading
        overviewLabel.text = "Overview"
        overviewLabel.font = UIFont(name: Fonts.interSemiBold, size: 18)
        
        /// Description content
        descriptionLabel.text = viewModel.overview
        descriptionLabel.font = UIFont(name: Fonts.interRegular, size: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
    }
    
    // MARK: - Animations
    private func animateContent() {
        /// Fade in elements with slight delay between each
        let elements = [imageView, titleLabel, ratingLabel, releaseDate, descriptionView]
        let initialAlpha: CGFloat = 0.0
        
        elements.forEach { $0?.alpha = initialAlpha }
        
        for (index, element) in elements.enumerated() {
            UIView.animate(
                withDuration: 0.5,
                delay: 0.1 * Double(index),
                options: .curveEaseInOut,
                animations: {
                    element?.alpha = 1.0
                }
            )
        }
    }
}

// MARK: - Helper Extensions
extension MovieDetailsViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        Kingfisher.ImageCache.default.clearMemoryCache()
    }
}
