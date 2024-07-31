//
//  ResultObject.swift
//  Moffy
//
//  Created by Trương Duy Tân on 19/04/2024.
//

import Foundation
import RealmSwift

class ResultObject: BaseObject {
    @Persisted var backdropPath: String?
    @Persisted var genreIDS = List<Int>()
    @Persisted var overview: String?
    @Persisted var posterPath: String?
    @Persisted var title: String?
    @Persisted var name: String?
    @Persisted var profilePath: String?
    
    convenience init(adult: Bool? = nil, backdropPath: String? = nil, genreIDS: List<Int> = List<Int>(), id: Int? = nil, gender: Int? = nil, budget: Int? = nil, originalLanguage: String? = nil, originalTitle: String? = nil, originalName: String? = nil, overview: String? = nil, popularity: Double? = nil, posterPath: String? = nil, releaseDate: String? = nil, title: String? = nil, firstAirDate: String? = nil, castId: Int? = nil, character: String? = nil, creditId: String? = nil, order: Int? = nil, knownForDepartment: String? = nil, name: String? = nil, video: Bool? = nil, voteAverage: Double? = nil, voteCount: Int? = nil, profilePath: String? = nil) {
        self.init()
        self.backdropPath = backdropPath
        self.genreIDS.append(objectsIn: genreIDS)
        self.overview = overview
        self.posterPath = posterPath
        self.title = title
        self.name = name
        self.profilePath = profilePath
    }
}
