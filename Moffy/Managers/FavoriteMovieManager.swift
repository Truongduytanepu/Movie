//
//  FavoriteMovieManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 19/04/2024.
//

import Foundation

class FavoriteMovieManager {
    static var shared = FavoriteMovieManager()
    
    @Published var tabSelected: TabSelectedType?
    @Published var address: String?
}

extension FavoriteMovieManager {
    func addMovieToFavorite() {
        
    }
}
