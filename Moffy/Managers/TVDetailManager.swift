//
//  TVDetailManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 05/04/2024.
//

import Foundation

class TVDetailManager {
    static var shared = TVDetailManager()
    @Published private(set) var tvDetail: MovieDetailModel?
    var numberOfSeason: Int {
        return tvDetail?.numberOfSeason ?? 0
    }
}

extension TVDetailManager {
    func fetch(_ genreID: String) {
        tvDetail = nil
        Task {
            do {
                let tvDetailResponse = try await APIManager.shared.getTvDetail(genreID)
                self.tvDetail = tvDetailResponse
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
