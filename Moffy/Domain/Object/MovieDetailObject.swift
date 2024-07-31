//
//  MovieDetailObject.swift
//  Moffy
//
//  Created by Trương Duy Tân on 19/04/2024.
//

import Foundation
import RealmSwift

class MovieDetailObject: BaseObject {
    @Persisted var idMovie: Int?
    @Persisted var posterPath: String?
    @Persisted var name: String?
    @Persisted var title: String?
    @Persisted var genreIds = List<Int>()
    
    convenience init(_ movie: MovieDetailModel) {
        self.init()
        self.id = incrementID()
        self.idMovie = movie.id
        self.posterPath = movie.posterPath
        self.name = movie.name
        self.title = movie.title
        for id in movie.genres.map({$0.id}) {
            self.genreIds.append(id ?? 0)
        }
    }
    
    private func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(MovieDetailObject.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
