//
//  ActorDetaiManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 28/03/2024.
//

import Foundation

class ActorDetailManager {
    static let shared = ActorDetailManager()
    @Published private(set) var actorDetail: ActorDetail?
}

extension ActorDetailManager {
    func fetch(_ personID: Int) {
        actorDetail = nil
        Task {
            do {
                let actorDetailData = try await APIManager.shared.getActorDetail(personID)
                self.actorDetail = actorDetailData
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    guard let self = self else {
                        return
                    }
                    fetch(personID)
                }
            }
        }
    }
}
