//
//  MoviePopularManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 25/03/2024.
//

import Foundation

class MoviePopularManager {
    static var shared = MoviePopularManager()
    @Published private(set) var moviePopular = [Result]()
}

extension MoviePopularManager {
    func fetch(_ page: Int, isLoadMore: Bool) {
        if !isLoadMore {
            moviePopular.removeAll()
        }
       
        Task {
            do {
                let moviePopular = try await APIManager.shared.getMoviePopular(page)
                self.moviePopular += moviePopular.results ?? [Result]()
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    guard let self = self else {
                        return
                    }
                    fetch(page, isLoadMore: false)
                }
            }
        }
    }
}
