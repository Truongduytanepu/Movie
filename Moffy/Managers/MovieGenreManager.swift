//
//  MovieGenreManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 02/02/2024.
//

import Foundation
import UIKit


class MovieGenreManager {
    static let shared = MovieGenreManager()
    @Published private(set) var movieGenre = [MovieGenre]()
    @Published private(set) var cacheMovies = [MovieGenreObject]()
}

extension MovieGenreManager {
    func fetch() {
        movieGenre.removeAll()
        Task {
            do {
                let movieGenresResponse = try await APIManager.shared.getGenreMovie()
                self.movieGenre = movieGenresResponse.genres ?? []
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    guard let self else {
                        return
                    }
                    fetch()
                }
            }
        }
    }
}

extension MovieGenreManager {
    func getMovieGenres() -> [MovieGenreObject] {
        return RealmService.shared.fetch(ofType: MovieGenreObject.self)
    }
    
    func saveMovieSelected(with movie: MovieGenreObject) {
        if let existingMovie = RealmService.shared.getById(ofType: MovieGenreObject.self, id: movie.id) {
            RealmService.shared.delete(existingMovie)
        } else {
            RealmService.shared.add(movie)
        }
        
    }

    func removeMovieExisting(with movie: MovieGenreObject) {
        if let existingMovie = RealmService.shared.getById(ofType: MovieGenreObject.self, id: movie.id) {
            RealmService.shared.delete(existingMovie)
        }
    }

    
    func convertIDToGenre(_ movie: Result) -> String {
        var genreText = ""
        
        for genreId in movie.genreIDS ?? [Int]() {
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
    
    func convertIDMovieObjectToGenre(_ movie: MovieObject) -> String {
        var genreText = ""
        
        for genreId in movie.genreIds  {
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
    
    func convertIDMovieToGenre(_ genreIds: [Int]) -> String {
        var genreText = ""
        
        for genreId in genreIds {
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

    
    func getGenreName(with genreId: Int) -> String {
        var genreText = ""
        
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
        
        if genreText.hasSuffix(" • ") {
            genreText.removeLast(3)
        }
        
        return genreText
    }
}
