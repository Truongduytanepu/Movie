//
//  MovieGenreId.swift
//  Moffy
//
//  Created by Trương Duy Tân on 19/02/2024.
//

import Foundation

class MovieGenreIdManager {
    static let shared = MovieGenreIdManager()
    @Published private(set) var movie = [Result]()
}

extension MovieGenreIdManager {
    func fetch(genreId: String, page: Int, isLoadMore: Bool) {
        if !isLoadMore {
            movie.removeAll()
        }
        
        Task {
            do {
                let movieSearchResponse = try await APIManager.shared.getGenreIdMovie(genreId: genreId,
                                                                                      page: page)
                self.movie += movieSearchResponse.results ?? [Result]()
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    guard let self = self else {
                        return
                    }
                    fetch(genreId: genreId, page: page, isLoadMore: false)
                }
            }
        }
    }
}
