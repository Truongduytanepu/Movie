//
//  ActorFavoriteObject.swift
//  Moffy
//
//  Created by Trương Duy Tân on 19/04/2024.
//

import Foundation
import RealmSwift

class ActorFavoriteObject: BaseObject {
    @Persisted var idActor: Int?
    @Persisted var name: String?
    @Persisted var department: String?
    @Persisted var profilePath: String?
    
    convenience init(_ actor: ActorDetail) {
        self.init()
        self.id = actor.id ?? 0
        self.name = actor.name
        self.department = actor.knownForDepartment
        self.profilePath = actor.profilePath
    }
    
    private func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(ActorFavoriteObject.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}


