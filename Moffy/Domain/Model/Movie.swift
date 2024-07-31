//
//  Movie.swift
//  Moffy
//
//  Created by Trương Duy Tân on 24/02/2024.
//

import Foundation

struct MovieResponse: Codable {
    var dates: Dates?
    var page: Int?
    var results: [Result]?
    var totalPages: Int?
    var totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Dates: Codable {
    var maximum: String?
    var minimum: String?
}

struct Result: Codable {
    var adult: Bool?
    var backdropPath: String?
    var genreIDS: [Int]?
    var id, gender: Int?
    var budget: Int?
    var originalLanguage, originalTitle, originalName, overview: String?
    var popularity: Double?
    var posterPath, releaseDate, title, firstAirDate: String?
    var castId: Int?
    var character: String?
    var creditId: String?
    var order: Int?
    var knownForDepartment, name: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var knownFor: [KnownFor]?
    var profilePath : String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case gender, budget
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case castId = "cast_id"
        case character
        case creditId = "credit_id"
        case order
        case knownForDepartment = "known_for_department"
        case name
        case knownFor = "known_for"
        case profilePath = "profile_path"
    }
}


//struct Movie: Codable {
//    var adult: Bool
//    var backdropPath: String?
//    var genreIDS: [Int]?
//    var id: Int
//    var originalLanguage: String?
//    var originalTitle: String?
//    var overview: String?
//    var popularity: Double?
//    var posterPath: String?
//    var releaseDate: String?
//    var title: String?
//    var video: Bool?
//    var voteAverage: Double?
//    var voteCount: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case adult
//        case backdropPath = "backdrop_path"
//        case genreIDS = "genre_ids"
//        case id
//        case originalLanguage = "original_language"
//        case originalTitle = "original_title"
//        case overview, popularity
//        case posterPath = "poster_path"
//        case releaseDate = "release_date"
//        case title, video
//        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
//    }
//}
