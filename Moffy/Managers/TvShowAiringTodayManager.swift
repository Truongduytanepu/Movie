//
//  TvShowAiringTodayManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 31/03/2024.
//

import Foundation

class TvShowAiringTodayManager {
    static let shared = TvShowAiringTodayManager()
    @Published private(set) var tvshowAiringToday = [Result]()
}

extension TvShowAiringTodayManager {
    func fetch(_ page: Int, _ isLoadMore: Bool) {
        if !isLoadMore {
            tvshowAiringToday.removeAll()
        }
        Task {
            do {
                let tvShowAiringResponse = try await APIManager.shared.getTvShowAiring(page)
                self.tvshowAiringToday += tvShowAiringResponse.results ?? [Result]()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

