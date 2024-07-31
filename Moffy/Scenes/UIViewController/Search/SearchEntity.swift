//
//  SearchEntity.swift
//  Moffy
//
//  Created by Trương Duy Tân on 23/02/2024.
//

import Foundation

struct SearchEntity {
    var sections: [Section] = []
    init() {}
    
    init(movieData: [Result], tvShowData: [Result], actorData: [Result]) {
        sections = []
        if !movieData.isEmpty {
            sections.append(.movie(data: movieData, titleSection: "Movies"))
        }
        if !tvShowData.isEmpty {
            sections.append(.tvShow(data: tvShowData, titleSection: "Tv Show"))
        }
        if !actorData.isEmpty {
            sections.append(.actor(data: actorData, titleSection: "Actor"))
        }
        
    }
    enum TypeView {
        case search
        case noSearch
    }
    
    enum Section {
        case movie(data: [Result], titleSection: String)
        case tvShow(data: [Result], titleSection: String)
        case actor(data: [Result], titleSection: String)
    }
}
