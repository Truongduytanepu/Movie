
//
//  ActorSearchManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/02/2024.
//

import Foundation

class ActorSearchManager {
    static let shared = ActorSearchManager()
    @Published private(set) var actorSearch = [Result]()
}

extension ActorSearchManager {
    func fetch(query: String, page: Int, isLoadMore: Bool) {
        if !isLoadMore {
            actorSearch.removeAll()
        }
        
        Task {
            do {
                let actorSearchResponse = try await APIManager.shared.getActorSearch(query: query, page: page)
                self.actorSearch += actorSearchResponse.results ?? []
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
