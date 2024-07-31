//
//  TvSearch.swift
//  Moffy
//
//  Created by Trương Duy Tân on 24/02/2024.
//

import Foundation

struct TvSearch: Codable {
    var page: Int?
    var results: [Result]?
    var totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
