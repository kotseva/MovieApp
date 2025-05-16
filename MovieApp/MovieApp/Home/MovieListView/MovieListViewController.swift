//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import CoreData
import Foundation
import SwiftUI

class MovieListViewController: UIViewController {
    var viewModel: MovieListViewModelProtocol
    private let cellReuseIdentifier = "NowPlayingCollectionViewCell"

    private let homeTabView = UIView()
    private var collectionView: UICollectionView!

    public init(_ managedObjectContext: NSManagedObjectContext) {
        self.viewModel = DummyMovieListViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupHomeTabView()
        setupCollectionView()

        Task { @MainActor in
            await viewModel.loadViewInitialData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }

    private func setupBackgroundView() {
        view.backgroundColor = .white
    }

    private func setupHomeTabView() {
        homeTabView.translatesAutoresizingMaskIntoConstraints = false
        homeTabView.backgroundColor = .clear
        view.addSubview(homeTabView)

        NSLayoutConstraint.activate([
            homeTabView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeTabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeTabView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeTabView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

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
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MovieListViewControllerProtocol {
    func updateView() {
        DispatchQueue.main.async { [self] in
            collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.moviesCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? LatestMovieCollectionViewCell  else {
            return UICollectionViewCell()
        }

        viewModel.checkAndHandleIfPaginationRequired(at: indexPath.row)

        if let movieModel = viewModel.movieInfoModel(at: indexPath.row) {
            cell.configure(with: movieModel)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20
        return CGSize(width: width, height: 100) // Adjust height as needed
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
}

