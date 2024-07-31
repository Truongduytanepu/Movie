//
//  PlanSuggestObject.swift
//  Moffy
//
//  Created by Trương Duy Tân on 25/02/2024.
//

import Foundation
import RealmSwift

class PlanSuggestObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var namePlan: String?
    @Persisted var movies = List<MovieObject>()
    @Persisted var endDate: Date?
    @Persisted var startDate: Date?
    @Persisted var generPlan: String?
    @Persisted var imagePlan: String?
    @Persisted var note: String?
    
    convenience init(with plan: PlanItem) {
        self.init()
        self.id = plan.namePlan ?? ""
        self.namePlan = plan.namePlan
        self.imagePlan = plan.image
        for movie in plan.movies ?? [MovieObject]() {
            self.movies.append(movie)
        }
        self.endDate = plan.endDate
        self.startDate = plan.startDate
        self.generPlan = plan.generPlan
        self.note = plan.note
    }
}
