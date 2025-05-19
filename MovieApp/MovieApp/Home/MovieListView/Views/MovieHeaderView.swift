//
//  MovieHeaderView.swift
//  MovieApp
//
//  Created by Angela Koceva on 19.5.25.
//

import UIKit

class MovieHeaderView: UIView {
    
    weak var delegate: MovieHeaderViewDelegate?
    var additionalTopPadding: CGFloat = 0 {
        didSet {
            updateHeaderConstraints()
        }
    }
    
    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private let searchButton = UIButton()
    private let filterButton = UIButton()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        setupBackgroundView()
        setupTitleLabel()
        setupSearchButton()
        setupFilterButton()
    }
    
    private func setupBackgroundView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        
        // Add subtle shadow to header
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.05
        
        addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Now Playing"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .black
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupSearchButton() {
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Use SF Symbol for search icon
        if #available(iOS 13.0, *) {
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
            searchButton.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: symbolConfig), for: .normal)
        } else {
            // Fallback for earlier iOS versions
            searchButton.setTitle("🔍", for: .normal)
        }
        
        searchButton.tintColor = .darkGray
        searchButton.layer.cornerRadius = 18
        searchButton.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            searchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 36),
            searchButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func setupFilterButton() {
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Use SF Symbol for filter icon
        if #available(iOS 13.0, *) {
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
            filterButton.setImage(UIImage(systemName: "line.horizontal.3.decrease", withConfiguration: symbolConfig), for: .normal)
        } else {
            // Fallback for earlier iOS versions
            filterButton.setTitle("≡", for: .normal)
        }
        
        filterButton.tintColor = .darkGray
        filterButton.layer.cornerRadius = 18
        filterButton.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -12),
            filterButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 36),
            filterButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    // MARK: - Actions
    @objc private func searchButtonTapped() {
        delegate?.didTapSearchButton()
    }
    
    @objc private func filterButtonTapped() {
        delegate?.didTapFilterButton()
    }
    
    // MARK: - Public Methods
    func updateBackgroundAlpha(_ alpha: CGFloat) {
        backgroundView.alpha = alpha
    }
    
    private func updateHeaderConstraints() {
        // Add additional top padding for dynamic island
        if additionalTopPadding > 0 {
            // Create or update top padding constraint
            for constraint in constraints {
                if constraint.firstAttribute == .height {
                    constraint.constant = 60 + additionalTopPadding
                    return
                }
            }
            
            // Add height constraint if not found
            heightAnchor.constraint(equalToConstant: 60 + additionalTopPadding).isActive = true
        }
    }
}

// MARK: - Protocol
protocol MovieHeaderViewDelegate: AnyObject {
    func didTapSearchButton()
    func didTapFilterButton()
}
