//
//  MovieGenre.swift
//  Moffy
//
//  Created by Trương Duy Tân on 24/02/2024.
//

import Foundation

struct GenreResponse: Codable {
    var genres: [MovieGenre]?
}

struct MovieGenre: Codable {
    var id: Int?
    var name: String?
}
