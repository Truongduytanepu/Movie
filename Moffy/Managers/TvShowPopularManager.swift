//
//  TvShowPopularManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 31/03/2024.
//

import Foundation

class TvShowPopularManager {
    static var shared = TvShowPopularManager()
    @Published private(set) var tvShowPopular = [Result]()
}

extension TvShowPopularManager {
    func fetch(_ page: Int, _ isLoadMore: Bool) {
        if !isLoadMore {
            tvShowPopular.removeAll()
        }
        
        Task {
            do {
                let tvShowPopularResponse = try await APIManager.shared.getTvShowPopular(page)
                self.tvShowPopular += tvShowPopularResponse.results ?? [Result]()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
