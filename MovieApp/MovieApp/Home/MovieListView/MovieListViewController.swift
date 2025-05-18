//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import CoreData
import Foundation
import SwiftUI

/// Base view controller displaying a list of movies using a collection view.
class MovieListViewController: UIViewController {
    var viewModel: MovieListViewModelProtocol
    private let cellReuseIdentifier = "NowPlayingCollectionViewCell"

    private let homeTabView = UIView()
    private var collectionView: UICollectionView!

    /// Initializes with a default dummy view model.
    init(viewModel: MovieListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    // Setup UI and trigger initial data load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupHomeTabView()
        setupCollectionView()
        
        Task { @MainActor in
            do {
                try await viewModel.loadViewInitialData()
            } catch {
                // Handle the error: show an alert or log it
                showAlert(with: "Failed to load movies. Please try again.")
                print("Error loading initial data: \(error)")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }

    private func setupBackgroundView() {
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
    }

    private func setupHomeTabView() {
        homeTabView.translatesAutoresizingMaskIntoConstraints = false
        homeTabView.backgroundColor = .clear
        view.addSubview(homeTabView)

        NSLayoutConstraint.activate([
            homeTabView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            homeTabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeTabView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeTabView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    /* Configures the collection view that displays movie items,
     sets its delegate, data source, appearance,
     registers the cell class, and adds it to the container view. */
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(LatestMovieCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)

        homeTabView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: homeTabView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: homeTabView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: homeTabView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: homeTabView.bottomAnchor)
        ])
    }
    
    /* Shows an alert with a given message.
     - Parameter message: The message string to display in the alert. */
    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, DataSource, Layout Methods
extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MovieListViewControllerProtocol {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.moviesCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? LatestMovieCollectionViewCell  else {
            return UICollectionViewCell()
        }

        if let movieModel = viewModel.movieInfoModel(at: indexPath.row) {
            cell.configure(with: movieModel)
        }

        return cell
    }
    
    // Triggers pagination when scrolling near the bottom of the list
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 1.5 {
            Task {
                await viewModel.checkAndHandleIfPaginationRequired(at: viewModel.moviesCount() - 1)
            }
        }
    }

    // Defines the size for each cell in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieModel = viewModel.movieInfoModel(at: indexPath.row) {
            let detailVC = MovieDetailsViewController(nibName: "MovieDetailsViewController", bundle: nil)
            detailVC.viewModel = movieModel
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

