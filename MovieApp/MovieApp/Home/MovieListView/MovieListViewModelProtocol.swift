//
//  MovieListViewModelProtocol.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import Foundation

protocol MovieListViewModelProtocol: AnyObject {
    
    var viewController: MovieListViewControllerProtocol? { get set }
    var isPaginating: Bool { get set }
    
    func didTap()
    func loadViewInitialData() async throws
    func moviesCount() -> Int
    func movieInfoModel(at index: Int) -> MovieInfoModel?
    func checkAndHandleIfPaginationRequired(at row: Int) async
}
