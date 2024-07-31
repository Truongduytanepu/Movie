//
//  MovieFavoriteObject.swift
//  Moffy
//
//  Created by Trương Duy Tân on 15/04/2024.
//

import Foundation
import RealmSwift

class MovieFavoriteObject: BaseObject {
    @Persisted var listMovie = List<MovieDetailObject>()
    
    convenience init(_ movieDetail: MovieDetailObject) {
        self.init()
        self.id = incrementID()
        self.listMovie.append(movieDetail)
    }
    
    private func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(MovieFavoriteObject.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
