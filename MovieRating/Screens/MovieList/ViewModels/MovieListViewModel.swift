//
//  MovieListViewModel.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 19/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//

import Foundation

protocol MovieListViewModelDelegate: class {
    func modelDidChange()
}

class MovieListViewModel {
    
    private var movies: [Movie] = []
    
    private var searchedResults: [Movie] = []
    
    private var isSearchActive: Bool = false
    
    private var displayingList: [Movie] {
        return isSearchActive
            ? searchedResults
            : movies
    }
    
    weak var delegate: MovieListViewModelDelegate?
    
    init() {}
    
    //MARK: - Table View Helpers
    
    func numberOfItems() -> Int {
        return displayingList.count
    }
    
    func item(at indexPath: IndexPath) -> Movie {
        return displayingList[indexPath.row]
    }
    
    //MARK: -
    
    func updateMovieList(_ movies: [Movie]) {
        self.movies = movies
        delegate?.modelDidChange()
    }
    
    //MARK: - Search helpers
    
    func activateSearch() {
        isSearchActive = true
        delegate?.modelDidChange()
    }
    
    func resetSearchList() {
        searchedResults = []
        isSearchActive = false
        delegate?.modelDidChange()
    }
    
    func searchTitle(_ searchText: String) {
        searchedResults = movies
            .filter {
                $0.title?.lowercased().contains(searchText.lowercased()) ?? false
            }
        delegate?.modelDidChange()
    }
}
