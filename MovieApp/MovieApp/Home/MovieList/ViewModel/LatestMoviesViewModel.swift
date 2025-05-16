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
    }
    
    func fetchNowPlayingData() async {
        do {
            let nowPlayingModel = try await networkManager.fetchNowPlaying(page: 1)
            handleNowPlayingResult(nowPlayingModel: nowPlayingModel)
        } catch {
            // TODO: Alert: Error occurred with possible refresh option
            print("Failed to fetch: \(error)")
            updateViewWithCachedMovieList()
        }
    }

//    func fetchNowPlayingData() async {
//        do {
//            let result = try await networkManager.fetchNowPlaying(page: 1)
//            guard let nowPlayingModel = result else {
//                self.updateViewWithCachedMovieList()
//                return
//            }
//            self.handleNowPlayingResult(nowPlayingModel: nowPlayingModel)
//        } catch {
//            
//            //TODO: Alert: Error occured with possible refresh option
//            print("Failed to fetch: \(error)")
//        }
//    }
    
    func loadViewInitialData() async {
        await fetchNowPlayingData()
    }

    func handleNowPlayingResult(nowPlayingModel: LatestMoviesResponseModel) {
        handlePageDetails(nowPlayingModel: nowPlayingModel)
        addMovieInfoModelToMovieList(nowPlayingModel.results)

        updateView()
        //        NowPlayingMOHandler.saveCurrentMovieList(dataModel.movieList, moc: managedObjectContext)
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
        //        let movieModelList = NowPlayingMOHandler.fetchSavedNowPlayingMovieList(in: managedObjectContext)
        //        addMovieInfoModelToMovieList(movieModelList)
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
    func checkAndHandleIfPaginationRequired(at row: Int) {
        //        if (row + 1 == dataModel.movieList.count) && (dataModel.currentPageNumber != dataModel.totalPages) {
        //            handlePaginationRequired()
        //        }
    }

    func handlePaginationRequired() {
        //        if !isLoading && dataModel.currentPageNumber != 0 {
        //            isLoading = true
        //            fetchNextPageNowPlayingData()
        //        }
    }
}
