//
//  LatestMoviesViewModel.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import CoreData
import Foundation

// MARK:- DataModel
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
public class NowPlayingViewModel: MovieListViewModelProtocol {
    var isPaginating: Bool
    
    weak var viewController: MovieListViewControllerProtocol?
    private var isLoading: Bool
    private let dataModel: NowPlayingViewDataModel
    private let managedObjectContext: NSManagedObjectContext
    private lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()

    init(_ moc: NSManagedObjectContext) {
        dataModel = NowPlayingViewDataModel()
        managedObjectContext = moc
        isLoading = true
        isPaginating = false
    }
    
    func fetchNowPlayingData() async {
        do {
            let nowPlayingModel = try await networkManager.fetchLatestMovies(page: 1)
            handleNowPlayingResult(nowPlayingModel: nowPlayingModel)
        } catch {
            // TODO: Alert: Error occurred with possible refresh option
            print("Failed to fetch: \(error)")
            updateViewWithCachedMovieList()
        }
    }
    
    func loadViewInitialData() async {
        await fetchNowPlayingData()
    }

    func handleNowPlayingResult(nowPlayingModel: LatestMoviesResponseModel) {
        handlePageDetails(nowPlayingModel: nowPlayingModel)
        addMovieInfoModelToMovieList(nowPlayingModel.results)

        updateView()
    }

    func handlePageDetails(nowPlayingModel: LatestMoviesResponseModel) {
        updateLastFetchedPageNumber(nowPlayingModel)
    }
    
    func addMovieInfoModelToMovieList(_ modelList: [MovieInfoModel]) {
        for movieInfoModel in modelList {
            dataModel.movieList.append(movieInfoModel)
        }
    }

    func updateLastFetchedPageNumber(
        _ nowPlayingModel: LatestMoviesResponseModel
    ) {
        dataModel.currentPageNumber = nowPlayingModel.page
        dataModel.totalPages = nowPlayingModel.totalPages
        print("\(dataModel.currentPageNumber) out of \(dataModel.totalPages)")
    }

    func updateViewWithCachedMovieList() {
        updateView()
    }

    func updateView() {
        isLoading = false
        viewController?.updateView()
    }

    // MARK: MovieListViewModelProtocol
    func didTap() {
        // Does nothing
    }

    func moviesCount() -> Int {
        return dataModel.movieList.count
    }

    func movieInfoModel(at index: Int) -> MovieInfoModel? {
        return dataModel.movieList[index]
    }

    func currentMOC() -> NSManagedObjectContext {
        return managedObjectContext
    }
}

// MARK: - Pagination
extension NowPlayingViewModel {
    func checkAndHandleIfPaginationRequired(at row: Int) async {
        if (row + 1 == dataModel.movieList.count) && (dataModel.currentPageNumber != dataModel.totalPages) {
            await handlePaginationRequired()
        }
    }

    func handlePaginationRequired() async {
        if !isLoading && dataModel.currentPageNumber != 0 {
            isLoading = true
            await fetchNowPlayingData()
        }
    }
}
