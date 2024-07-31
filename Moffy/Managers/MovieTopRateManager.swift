//
//  MovieTopRateManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 18/02/2024.
//

import Foundation

class MovieTopRateManager {
    static let shared = MovieTopRateManager()
    @Published private(set) var topRateMovie = [Result]()
    @Published private(set) var movieGenreId: [Result] = []
    @Published var cacheMovies: [MovieObject] = []
    @Published var cacheMoviesPlan: [MovieObject] = []
    @Published var cacheCoverPlan: String = ""
    @Published var cacheCoverPlan1: String = ""
    @Published var checkEditOrCreatePlan: Int?
    @Published var movieDefaultRealm: [MovieObject] = []
    @Published var movieChooseArray: [MovieObject] = []
    @Published var checkCreate: Bool?
}

extension MovieTopRateManager {
    func fetch(_ page: Int, isLoadMore: Bool) {
        if !isLoadMore {
            topRateMovie.removeAll()
        }
        
        Task {
            do {
                let movieGenresResponse = try await APIManager.shared.getMovieTopRate(page)
                self.topRateMovie += movieGenresResponse.results ?? [Result]()
                getMovieId(movie: movieGenresResponse.results ?? [Result]())
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
    
    func getMovieId(movie: [Result]) {
        let genresId = MovieGenreManager.shared.getMovieGenres()
        for i in genresId {
            let array = movie.filter({$0.genreIDS!.contains(where: {$0 == i.id}) })
            fillterArray(array)
        }
    }
    
    func fillterArray(_ movie: [Result]) {
        for i in movie {
            if !self.movieGenreId.contains(where: {$0.id == i.id}) {
                self.movieGenreId.append(i)
            }
        }
    }
    
    func add(name: String, id: Int) {
        let genreObject = TVGenreObject()
        genreObject.name = name
        genreObject.id = id
        RealmService.shared.add(genreObject)
    }
    
    func getRandomMovies(from movies: [MovieObject]) -> [MovieObject] {
        var randomMovies: [MovieObject] = []
        let shuffledMovies = movies.shuffled()
        let count = min(8, shuffledMovies.count)
        
        var indexSet = Set<Int>()
        
        while randomMovies.count < count {
            let randomIndex = Int.random(in: 0..<shuffledMovies.count)
            if !indexSet.contains(randomIndex) {
                indexSet.insert(randomIndex)
                randomMovies.append(shuffledMovies[randomIndex])
            }
        }
        return randomMovies
    }
    
}

extension MovieTopRateManager {
    func saveMovieSelected(with movie: MovieObject) {
        if !self.cacheMovies.contains(where: { $0.idMovie == movie.idMovie}) {
            self.cacheMovies.append(movie)
        }else {
            self.cacheMovies.removeAll(where: { $0.idMovie == movie.idMovie})
        }
    }
    
    func saveMovieToPlan(with movie: MovieObject) {
        if !self.movieChooseArray.contains(where: { $0.idMovie == movie.idMovie}) {
            self.movieChooseArray.append(movie)
        }else {
            self.movieChooseArray.removeAll(where: { $0.idMovie == movie.idMovie})
        }
    }
    
    func saveCoverMovieSelected(with movie: MovieObject) {
        if self.cacheCoverPlan1 != movie.posterPath {
            self.cacheCoverPlan1 = movie.posterPath ?? ""
        } 
    }
}
