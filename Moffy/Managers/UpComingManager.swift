//
//  UpComingManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/03/2024.
//

import Foundation

class UpComingManager {
    static let share = UpComingManager()
    @Published private(set) var upComing = [Result]()
}

extension UpComingManager {
    func fetch(_ page: Int, isLoadMore: Bool) {
        if !isLoadMore {
            upComing.removeAll()
        }
        
        Task {
            do {
                let upComingMovie = try await APIManager.shared.getMovieUpComing(page)
                self.upComing += upComingMovie.results ?? [Result]()
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
