//
//  TVTopRateManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 20/02/2024.
//

import Foundation

class TVTopRateManager {
    static let shared = TVTopRateManager()
    @Published private(set) var topRateTV = [Result]()
    @Published private(set) var tvGenreId: [Result] = []
}

extension TVTopRateManager {
    func fetch(_ page: Int, isLoadMore: Bool) {
        if !isLoadMore {
            topRateTV.removeAll()
        }
        
        Task {
            do {
                let tvGenresResponse = try await APIManager.shared.getTVTopRate(page)
                self.topRateTV += tvGenresResponse.results ?? [Result]()
                getTVId(tv: tvGenresResponse.results ?? [Result]())
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    guard let self = self else {
                        return
                    }
                    fetch(page, isLoadMore: false)
                }
            }
        }
    }
    
    func getTVId(tv: [Result]) {
        let genresId = TVGenresManager.shared.getTVGenres()
        for i in genresId {
            let array = tv.filter({$0.genreIDS!.contains(where: {$0 == i.id}) })
            fillterArray(array)
        }
    }
    
    func fillterArray(_ movie: [Result]) {
        for i in movie {
            if !self.tvGenreId.contains(where: {$0.id == i.id}) {
                self.tvGenreId.append(i)
            }
        }
    }
}
