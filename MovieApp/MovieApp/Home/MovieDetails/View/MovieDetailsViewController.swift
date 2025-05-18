//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Angela Koceva on 18.5.25.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: MovieInfoModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 1.5, animations: {
        })
    }
    
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        title = "Movie Details"
        
        // Image
        ImageHelper.setupImageForView(imageView, imagePath: viewModel.posterPath)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        // Title
        titleLabel.text = viewModel.title
        titleLabel.font = UIFont(name: Fonts.interBold, size: 24)
        titleLabel.numberOfLines = 0
        
        // Rating
        ratingLabel.text = "⭐️ \(String(format: "%.1f", viewModel.voteAverage))"
        ratingLabel.font = UIFont(name: Fonts.interRegular, size: 16)
        ratingLabel.textColor = .gray
        
        //Release Date
        releaseDate.text = "Release date:\n\(viewModel.formattedReleaseDate)"
        releaseDate.font = UIFont(name: Fonts.interRegular, size: 16)
        releaseDate.numberOfLines = 0
        
        
        // Description
        descriptionView.layer.cornerRadius = 10
        stackView.spacing = 20
        stackView.backgroundColor = .clear
        
        // Overview
        overviewLabel.text = "Overview"
        overviewLabel.font = UIFont(name: Fonts.interSemiBold, size: 18)
        
        // Description
        descriptionLabel.text = viewModel.overview

        descriptionLabel.font = UIFont(name: Fonts.interRegular, size: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
    }
    
    // MARK: - Navigation Bar Setup
    private func setupNavigationBar() {
        title = "Movie Details"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}
