//
//  LatestMoviesViewModel.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import CoreData
import Foundation

// MARK: - DataModel
class NowPlayingViewDataModel {
    var movieList: [MovieInfoModel]
    var currentPageNumber: Int
    var totalPages: Int

    init() {
        movieList = []
        currentPageNumber = 0
        totalPages = 100
    }
}

// MARK: - ViewModel
public class MovieListViewModel: MovieListViewModelProtocol {

    weak var viewController: MovieListViewControllerProtocol?
    var isPaginating: Bool = false
    private var isLoading: Bool = false

    private let context: NSManagedObjectContext
    private var dataModel = NowPlayingViewDataModel()
    private let networkManager: NetworkManager

    init(context: NSManagedObjectContext, networkManager: NetworkManager = NetworkManager()) {
        self.context = context
        self.networkManager = networkManager
    }

    public func loadViewInitialData() async {
        await fetchNowPlayingData(for: 1)
    }

    private func fetchNowPlayingData(for page: Int) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await networkManager.fetchLatestMovies(page: page)
            handleNowPlayingResult(result)
        } catch {
            print("❌ Fetch error: \(error)")
            loadCachedDataIfAvailable()
        }
    }

    private func handleNowPlayingResult(_ result: LatestMoviesResponseModel) {
        dataModel.currentPageNumber = result.page
        dataModel.totalPages = result.totalPages
        dataModel.movieList.append(contentsOf: result.results)
        viewController?.updateView()
    }

    private func loadCachedDataIfAvailable() {
        viewController?.updateView()
    }

    public func didTap() {}

    public func moviesCount() -> Int {
        dataModel.movieList.count
    }

    func movieInfoModel(at index: Int) -> MovieInfoModel? {
        guard index >= 0 && index < dataModel.movieList.count else { return nil }
        return dataModel.movieList[index]
    }

    public func currentMOC() -> NSManagedObjectContext {
        context
    }

    public func checkAndHandleIfPaginationRequired(at row: Int) async {
        guard row == dataModel.movieList.count - 1,
              dataModel.currentPageNumber < dataModel.totalPages else { return }

        isPaginating = true
        await fetchNowPlayingData(for: dataModel.currentPageNumber + 1)
        isPaginating = false
    }
}
