//
//  ActorPopularManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/03/2024.
//

import Foundation

class ActorPopularManager {
    static var shared = ActorPopularManager()
    @Published private(set) var actorPopular = [Result]()
}

extension ActorPopularManager {
    func fetch(_ page: Int, isLoadMore: Bool) {
        if !isLoadMore {
            actorPopular.removeAll()
        }
        
        Task {
            do {
                let actorResponse = try await APIManager.shared.getActorPopular(page)
                self.actorPopular += actorResponse.results ?? []
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
}
