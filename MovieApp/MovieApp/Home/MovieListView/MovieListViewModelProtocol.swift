//
//  MovieListViewModelProtocol.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import Foundation
import CoreData

protocol MovieListViewModelProtocol: AnyObject {
    
    var viewController: MovieListViewControllerProtocol? { get set }
    
    func didTap()
    func loadViewInitialData() async
    func moviesCount() -> Int
    func movieInfoModel(at index: Int) -> MovieInfoModel?
    func currentMOC() -> NSManagedObjectContext
    func checkAndHandleIfPaginationRequired(at row: Int)
}

class DummyMovieListViewModel: MovieListViewModelProtocol {
    
    weak var viewController: MovieListViewControllerProtocol?
    
    init() {
        
    }
    
    func didTap() {
        
    }
    
    func loadViewInitialData() {
        
    }
    
    func moviesCount() -> Int {
        return 0
    }
    
    func movieInfoModel(at index: Int) -> MovieInfoModel? {
        return nil
    }
    
    func currentMOC() -> NSManagedObjectContext {
        return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    func checkAndHandleIfPaginationRequired(at row: Int) {
    }
}
