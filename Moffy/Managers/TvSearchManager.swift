//
//  TvSearchManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 20/02/2024.
//

import Foundation

class TvSearchManager {
    static let shared = TvSearchManager()
    @Published private(set) var searchTV = [Result]()
}

extension TvSearchManager {
    func fetch(query: String, page: Int, isLoadMore: Bool) {
        if !isLoadMore {
            searchTV.removeAll()
        }
        
        Task {
            do {
                let tvSearchResponse = try await APIManager.shared.getTvSearch(query: query, page: page)
                self.searchTV += tvSearchResponse.results ?? []
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    guard let self = self else {
                        return
                    }
                    fetch(query: query, page: page, isLoadMore: false)
                }
            }
        }
    }
}
