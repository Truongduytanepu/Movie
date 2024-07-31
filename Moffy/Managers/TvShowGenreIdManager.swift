//
//  TvShowGenreIdManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 31/03/2024.
//

import Foundation

class TvShowGenreIdManager {
    static var shared = TvShowGenreIdManager()
    @Published private(set) var tvShowGenreId = [Result]()
}

extension TvShowGenreIdManager {
    func fetch(_ genreId: String, page: Int, isLoadMore: Bool) {
        if !isLoadMore {
            tvShowGenreId.removeAll()
        }
        
        Task {
            do {
                let tvShowGenreResponse = try await APIManager.shared.getTvShowGenreId(genreId, page: page)
                
                DispatchQueue.main.async {
                    self.tvShowGenreId += tvShowGenreResponse.results ?? [Result]()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
}
