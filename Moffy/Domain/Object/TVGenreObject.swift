//
//  TVGenreObject.swift
//  Moffy
//
//  Created by Trương Duy Tân on 24/02/2024.
//

import Foundation
import RealmSwift

class TVGenreObject: BaseObject {
  @Persisted var name: String?
    
    convenience init(with genre: MovieGenre) {
        self.init()
        self.id = genre.id ?? 1
        self.name = genre.name
    }
}
