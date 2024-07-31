//
//  Eposides.swift
//  Moffy
//
//  Created by Trương Duy Tân on 10/04/2024.
//

import Foundation

// MARK: - Eposides
struct Eposides: Codable {
    var id, airDate: String?
    var episodes: [Episode]?
    var name, overview: String?
    var seasonNumber: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case airDate = "air_date"
        case episodes, name, overview
        case seasonNumber = "season_number"
    }
}

// MARK: - Episode
struct Episode: Codable {
    var episodeNumber: Int?
    var id: Int?
    var name, overview: String?
    var stillPath: String?

    enum CodingKeys: String, CodingKey {
        case episodeNumber = "episode_number"
        case id, name, overview
        case stillPath = "still_path"
    }
}

enum EpisodeType: String, Codable {
    case standard = "standard"
}

enum Character: String, Codable {
    case characterSelf = "Self"
    case empty = ""
}

enum KnownForDepartment: String, Codable {
    case acting = "Acting"
    case creator = "Creator"
    case directing = "Directing"
    case production = "Production"
    case sound = "Sound"
    case writing = "Writing"
}
