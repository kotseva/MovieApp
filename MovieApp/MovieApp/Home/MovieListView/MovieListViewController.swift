//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import UIKit

class MovieListViewController: UIViewController {
    var viewModel: MovieListViewModelProtocol
    private let cellReuseIdentifier = "NowPlayingCollectionViewCell"

    private let mainContentView = UIView()
    private var collectionView: UICollectionView!
    private var headerView: MovieHeaderView!
    private var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Initialization
    init(viewModel: MovieListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupMainContentView()
        setupHeaderView()
        setupCollectionView()
        setupLoadingIndicator()
        
        Task { @MainActor in
            do {
                showLoading(true)
                try await viewModel.loadViewInitialData()
                showLoading(false)
            } catch {
                showLoading(false)
                showAlert(with: "Failed to load movies. Please try again.")
                print("Error loading initial data: \(error)")
            }
        }
        
        //Just for testing the schemes
        print("Current environment: \(Environment.currentEnvironment)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Setting header opacity to full
        headerView.updateBackgroundAlpha(1.0)
        
        // Enable proper layout with dynamic island and notched devices
        if #available(iOS 15.0, *) {
            let window = view.window?.windowScene?.keyWindow
            let topPadding = window?.safeAreaInsets.top ?? 0
            
            // Adjust header view height for dynamic island
            if topPadding > 47 {
                headerView.additionalTopPadding = topPadding - 47
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Make sure bottom content is not covered by tab bar
        let bottomPadding = tabBarController?.tabBar.frame.height ?? 0
        collectionView.contentInset.bottom = bottomPadding + 10
        collectionView.verticalScrollIndicatorInsets.bottom = bottomPadding
    }

    // MARK: - UI Setup
    private func setupBackgroundView() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
    }

    private func setupMainContentView() {
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        mainContentView.backgroundColor = .clear
        view.addSubview(mainContentView)

        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: view.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupHeaderView() {
        headerView = MovieHeaderView(frame: .zero)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.delegate = self
        mainContentView.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupCollectionView() {
        let layout = createCollectionViewLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        collectionView.contentInsetAdjustmentBehavior = .always
        
        // Add additional padding at the bottom to prevent tab bar overlap
        var bottomInset: CGFloat = 0
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            bottomInset = window.safeAreaInsets.bottom
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: bottomInset + 80, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 5, left: 0, bottom: bottomInset + 80, right: 0)
        
        collectionView.register(LatestMovieCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        mainContentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 20, right: 0)
        return layout
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .black
        
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showLoading(_ show: Bool) {
        if show {
            loadingIndicator.startAnimating()
            collectionView.isHidden = true
        } else {
            loadingIndicator.stopAnimating()
            collectionView.isHidden = false
        }
    }

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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? LatestMovieCollectionViewCell else {
            return UICollectionViewCell()
        }

        if let movieModel = viewModel.movieInfoModel(at: indexPath.row) {
            cell.configure(with: movieModel)
            
            // Apply shadow and additional styling to cells
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 4
            cell.layer.shadowOpacity = 0.1
            cell.layer.masksToBounds = false
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Add animation for cells appearing
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        UIView.animate(withDuration: 0.3, delay: 0.05 * Double(indexPath.row % 5), options: .curveEaseOut) {
            cell.alpha = 1
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        // Trigger pagination when user scrolls near the bottom
        if offsetY > contentHeight - height * 1.5 {
            Task {
                await viewModel.checkAndHandleIfPaginationRequired(at: viewModel.moviesCount() - 1)
            }
        }
        
        if offsetY > 0 {
            let headerAlpha = min(1, max(0.95, 1 - (offsetY / 80)))
            headerView.updateBackgroundAlpha(headerAlpha)
        } else {
            headerView.updateBackgroundAlpha(1.0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            // Add selection feedback animation
            UIView.animate(withDuration: 0.15, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.15) {
                    cell.transform = CGAffineTransform.identity
                } completion: { _ in
                    // Navigate to details view
                    if let movieModel = self.viewModel.movieInfoModel(at: indexPath.row) {
                        let detailVC = MovieDetailsViewController(nibName: "MovieDetailsViewController", bundle: nil)
                        detailVC.viewModel = movieModel
                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
            }
        }
    }
    
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - MovieHeaderViewDelegate
extension MovieListViewController: MovieHeaderViewDelegate {
    
    //TODO: - Search action
    func didTapSearchButton() {
        viewModel.didTap()
    }
    
    //TODO: - Search action
    func didTapFilterButton() {
    }
}
