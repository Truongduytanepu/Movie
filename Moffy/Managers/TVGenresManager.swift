//
//  TVGenresManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 16/02/2024.
//

import Foundation

class TVGenresManager {
    static let shared = TVGenresManager()
    
    @Published private(set) var tvGenre = [MovieGenre]()
    @Published private(set) var cacheMovies = [TVGenreObject]()
}

extension TVGenresManager {
    func fetch() {
        tvGenre.removeAll()
        Task {
            do {
                let tvGenresResponse = try await APIManager.shared.getGenreTV()
                self.tvGenre = tvGenresResponse.genres ?? []
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
    
    func saveTVSelected(with tv: TVGenreObject) {
        if let existingMovie = RealmService.shared.getById(ofType: TVGenreObject.self, id: tv.id) {
            RealmService.shared.delete(existingMovie)
        } else {
            RealmService.shared.add(tv)
        }
    }

    
    func getTVGenres() -> [TVGenreObject] {
        return RealmService.shared.fetch(ofType: TVGenreObject.self)
    }
    
    func removeTVExisting(with tv: TVGenreObject) {
        if let existingTV = RealmService.shared.getById(ofType: TVGenreObject.self, id: tv.id) {
            RealmService.shared.delete(existingTV)
        }
    }
}
