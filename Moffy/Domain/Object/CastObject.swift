//
//  CastObject.swift
//  Moffy
//
//  Created by Trương Duy Tân on 19/04/2024.
//

import Foundation
import RealmSwift

class CastObject: BaseObject {
    @Persisted var cast: List<ResultObject>
    
    convenience init(cast: List<ResultObject> = List<ResultObject>()) {
        self.init()
        self.cast.append(objectsIn: cast)
    }
}
