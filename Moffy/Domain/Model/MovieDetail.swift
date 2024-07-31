//
//  MovieDetail.swift
//  Moffy
//
//  Created by Trương Duy Tân on 02/04/2024.
//

import Foundation

// MARK: - MovieDetail
struct MovieDetailModel: Codable {
    var adult: Bool?
    var backdropPath: String?
    var belongsToCollection: BelongsToCollection?
    var budget: Int?
    var genres: [Genre]
    var homepage: String?
    var id: Int?
    var imdbID: String?
    var originalTitle: String?
    var overview: String?
    var popularity: Double?
    var posterPath: String?
    var releaseDate: String?
    var revenue: Int?
    var runtime: Int?
    var status: String?
    var tagline: String?
    var title: String?
    var name: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var videos: Videos?
    var credits: Credits?
    var recommendations: Recommendations?
    var reviews: Reviews?
    var seasons: [Season]?
    var numberOfSeason: Int?
    var firstAirDate: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
//        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue, runtime
        case status, tagline, title, name, video, credits
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case videos, recommendations, reviews, seasons
        case numberOfSeason = "number_of_seasons"
        case firstAirDate = "first_air_date"
    }
}

// MARK: - BelongsToCollection
struct BelongsToCollection: Codable {
    var id: Int?
    var name, posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

// MARK: - Credits
struct Credits: Codable {
    var cast, crew: [Result]?
}

// MARK: - Genre
struct Genre: Codable {
    var id: Int?
    var name: String?
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    var id: Int?
    var logoPath, name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    var name: String?

    enum CodingKeys: String, CodingKey {
        case name
    }
}

// MARK: - Recommendations
struct Recommendations: Codable {
    var page: Int?
    var results: [Result]?
    var totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - RecommendationsResult
//struct RecommendationsResult: Codable {
//    var adult: Bool?
//    var backdropPath: String?
//    var id: Int?
//    var title: String?
//    var name: String?
//    var originalTitle, overview, posterPath: String?
//    var genreIDS: [Int]?
//    var popularity: Double?
//    var releaseDate: String?
//    var video: Bool?
//    var voteAverage: Double?
//    var voteCount: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case adult
//        case backdropPath = "backdrop_path"
//        case id, title, name
//        case originalTitle = "original_title"
//        case overview
//        case posterPath = "poster_path"
//        case genreIDS = "genre_ids"
//        case popularity
//        case releaseDate = "release_date"
//        case video
//        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
//    }
//}

// MARK: - Media
//enum Media: String, Codable {
//    case movie = "movie"
//}
//enum OriginCountry: String, Codable {
//    case us = "US"
//}
//
//enum OriginalLanguage: String, Codable {
//    case en = "en"
//}

// MARK: - Reviews
struct Reviews: Codable {
    var page: Int?
    var results: [ReviewsResult]?
    var totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - ReviewsResult
struct ReviewsResult: Codable {
    var author: String?
    var authorDetails: AuthorDetails?
    var content, createdAt, id, updatedAt: String?
    var url: String?

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

// MARK: - AuthorDetails
struct AuthorDetails: Codable {
    var name, username: String?
    var avatarPath: String?
    var rating: Double?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    var englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

// MARK: - Videos
struct Videos: Codable {
    var results: [VideosResult]?
}

// MARK: - VideosResult
struct VideosResult: Codable {
    var name, key: String?
    var size: Int?
    var type: String?
    var official: Bool?
    var publishedAt, id: String?

    enum CodingKeys: String, CodingKey {
        case name, key, size, type, official
        case publishedAt = "published_at"
        case id
    }
}

// MARK: - Site
//enum Site: String, Codable {
//    case youTube = "YouTube"
//}
//


struct Season: Codable {
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}
