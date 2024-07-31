//
//  MovieSearchManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 19/02/2024.
//

import Foundation

class MovieSearchManager {
    static let shared = MovieSearchManager()
    static var selectedMovie: [Int] = []
    @Published private(set) var searchMovie = [Result]()
}

extension MovieSearchManager {
    func fetch(query: String, page: Int, isLoadMore: Bool) {
        if !isLoadMore {
            searchMovie.removeAll()
        }
        
        Task {
            do {
                let movieSearchResponse = try await APIManager.shared.getMovieSearch(query: query, page: page)
                self.searchMovie += movieSearchResponse.results ?? []
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    guard let self = self else {
                        return
                    }
                    fetch(query: query, page: page, isLoadMore: false)
                }
            }
        }
    }
}
