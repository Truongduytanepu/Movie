//
//  MovieDetailManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 02/04/2024.
//

import Foundation

class MovieDetailManager {
    static var shared = MovieDetailManager()
    @Published private(set) var movieDetail: MovieDetailModel?
    @Published var movieDetailBack: Bool?
}

extension MovieDetailManager {
    func fetch(_ genreID: String) {
        movieDetail = nil
        Task {
            do {
                let movieDetailResponse = try await APIManager.shared.getmovieDetail(genreID)
                self.movieDetail = movieDetailResponse
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func convertMovieDetailIDToGenre(_ movie: MovieDetailModel) -> String {
        var genreText = ""
        
        for genreId in movie.genres.map({$0.id }) {
            switch genreId {
            case 12:
                genreText += "Adventure • "
            case 14:
                genreText += "Fantasy • "
            case 16:
                genreText += "Animation • "
            case 18:
                genreText += "Drama • "
            case 27:
                genreText += "Horror • "
            case 28:
                genreText += "Action • "
            case 35:
                genreText += "Comedy • "
            case 36:
                genreText += "History • "
            case 37:
                genreText += "Western • "
            case 53:
                genreText += "Thriller • "
            case 80:
                genreText += "Crime • "
            case 99:
                genreText += "Documentary • "
            case 10402:
                genreText += "Music • "
            case 878:
                genreText += "Science Fiction • "
            case 9648:
                genreText += "Mystery • "
            case 10749:
                genreText += "Romance • "
            case 10751:
                genreText += "Family • "
            case 10752:
                genreText += "War • "
            case 10759:
                genreText += "Action & Adventure • "
            case 10763:
                genreText += "News"
            case 10764:
                genreText += "Reality"
            case 10765:
                genreText += "Sci-Fi & Fantasy • "
            case 10766:
                genreText += "Soap • "
            case 10767:
                genreText += "Talk • "
            case 10768:
                genreText += "War & Politics • "
            case 10770:
                genreText += "TV Movie • "
            default:
                break
            }
        }
        
        if genreText.hasSuffix(" • ") {
            genreText.removeLast(3)
        }
        
        return genreText
    }
    
    func convertToMovieObjects(results: MovieDetailModel) -> MovieObject {
        let movieObject = MovieObject()
        movieObject.idMovie = results.id
        movieObject.title = results.title ?? ""
        movieObject.name = results.name ?? ""
        movieObject.overview = results.overview ?? ""
        movieObject.posterPath = results.posterPath ?? ""
        movieObject.releaseDate = results.firstAirDate ?? ""
        movieObject.voteAverage = results.voteAverage ?? 0.0
        movieObject.voteCount = results.voteCount ?? 0
        movieObject.adult = results.adult ?? false
        movieObject.backdropPath = results.backdropPath ?? ""
        movieObject.video = results.video ?? false
        movieObject.popularity = results.popularity ?? 0.0
        
        let genreIds = results.genres.map({ $0.id })
        for genreId in genreIds {
            movieObject.genreIds.append(genreId ?? 0)
        }
        return movieObject
    }
}
