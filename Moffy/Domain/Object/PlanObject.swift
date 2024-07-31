//
//  PlanObject.swift
//  Moffy
//
//  Created by Trương Duy Tân on 24/02/2024.
//

import Foundation
import RealmSwift

class PlanObject: BaseObject {
    @Persisted var namePlan: String?
    @Persisted var movies = List<MovieObject>()
    @Persisted var endDate: Date?
    @Persisted var startDate: Date?
    @Persisted var generPlan: String?
    @Persisted var image: String?
    @Persisted var note: String?
    
    convenience init(with plan: PlanItem) {
        self.init()
        self.id = incrementID()
        self.namePlan = plan.namePlan
        for movie in plan.movies ?? [MovieObject]() {
            self.movies.append(movie)
        }
        self.endDate = plan.endDate
        self.startDate = plan.startDate
        self.generPlan = plan.generPlan
        self.image = plan.image
        self.note = plan.note
    }
    
    private func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(PlanObject.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
