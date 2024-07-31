//
//  BaseObject.swift
//  Moffy
//
//  Created by Trương Duy Tân on 24/02/2024.
//

import Foundation
import RealmSwift

class BaseObject: Object {
  @Persisted(primaryKey: true) var id: Int
}
