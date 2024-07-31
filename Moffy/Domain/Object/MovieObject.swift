//
//  MovieObject.swift
//  Moffy
//
//  Created by Trương Duy Tân on 24/02/2024.
//

import Foundation
import RealmSwift

class MovieObject: Object {
    @Persisted var id: String?
    @Persisted var idMovie: Int?
    @Persisted var name: String?
    @Persisted var title: String?
    @Persisted var overview: String?
    @Persisted var posterPath: String?
    @Persisted var releaseDate: String?
    @Persisted var voteAverage: Double?
    @Persisted var voteCount: Int?
    @Persisted var adult: Bool?
    @Persisted var backdropPath: String?
    @Persisted var genreIds = List<Int>()
    @Persisted var originalLanguage: String?
    @Persisted var video: Bool?
    @Persisted var popularity: Double?
    @Persisted var firstAirDate: String?
    @Persisted var isDone: Bool
    
    convenience init(_ movie: Result) {
        self.init()
        self.id = movie.name ?? movie.title
        self.idMovie = movie.id
        self.name = movie.name
        self.title = movie.title
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.voteAverage = movie.voteAverage
        self.voteCount = movie.voteCount
        self.adult = movie.adult
        self.backdropPath = movie.backdropPath
        for id in movie.genreIDS ?? [Int]() {
            self.genreIds.append(id)
        }
        self.video = movie.video
        self.popularity = movie.popularity
        self.firstAirDate = movie.firstAirDate
        self.isDone = false
    }
}
