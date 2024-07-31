//
//  RealmService.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import Foundation
import RealmSwift

class RealmService {
    static let shared = RealmService()
    
    private let realmConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
}

extension RealmService {
    func fetch<T: Object>(ofType type: T.Type) -> [T] {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            let results = realm.objects(type.self)
            return Array(results)
        } catch {
            return []
        }
    }
    
    func getById<T: Object>(ofType type: T.Type, id: Int) -> T? {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            let result = realm.objects(type.self).filter("id == %@", id).first
            return result
        } catch {
            return nil
        }
    }
    
    func getByIdMovie<T: Object>(ofType type: T.Type, idMovie: Int) -> T? {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            let result = realm.objects(type.self).filter("idMovie == %@", idMovie).first
            return result
        } catch {
            return nil
        }
    }
    
    func updateBy(namePlan: String, data: [String: Any]) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            if let planObject = realm.objects(PlanObject.self).filter("namePlan == %@", namePlan).first {
                try realm.write {
                    for (key, value) in data {
                        planObject.setValue(value, forKey: key)
                    }
                }
            }
        } catch {
            print("Error updating object with namePlan \(namePlan): \(error.localizedDescription)")
        }
    }
    
    func updateAllPlanMovies(plan: PlanObject, newMovieArray: [MovieObject]) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            try realm.write {
                plan.movies.removeAll()
                
                for movie in newMovieArray {
                    plan.movies.append(movie)
                }
            }
        } catch {
            print("Error updating all plan movies: \(error.localizedDescription)")
        }
    }
    
    func addMovieToPlan(_ plan: PlanObject, _ movie: MovieObject) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            try realm.write {
                if plan.movies.count == 20 {
                    print("qua 20 ptu")
                } else {
                    if plan.movies.contains(where: { $0.idMovie == movie.idMovie }) {
                        print("Movie is already in the plan.")
                    } else {
                        plan.movies.append(movie)
                    }
                }
            }
        } catch {
            print("Error adding movie to plan: \(error.localizedDescription)")
        }
    }

    func removeMovieFromPlan(_ plan: PlanObject, _ movie: MovieObject) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            try realm.write {
                if let existingMovieIndex = plan.movies.firstIndex(where: { $0.idMovie == movie.idMovie }) {
                    plan.movies.remove(at: existingMovieIndex)
                } else {
                    print("Movie is not in the plan.")
                }
            }
        } catch {
            print("Error removing movie from plan: \(error.localizedDescription)")
        }
    }

    func addMovieToFavorite(_ movieFavorite: MovieFavoriteObject, _ movieDetail: MovieDetailObject) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            try realm.write {
                if !movieFavorite.listMovie.contains(where: { $0.idMovie == movieDetail.idMovie }) {
                    movieFavorite.listMovie.append(movieDetail)
                } else {
                    print("Movie is already in the favorites.")
                }
            }
        } catch {
            print("Error adding movie to favorites: \(error.localizedDescription)")
        }
    }

    
    func add(_ object: Object) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            try realm.write {
                realm.add(object)
            }
        } catch {}
    }
    
    func delete(_ object: Object) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            try realm.write {
                realm.delete(object)
            }
        } catch {}
    }
    
    func update(_ object: Object, data: [String: Any]) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            try realm.write {
                for (key, value) in data {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {}
    }
    
    func delete<T: Object>(ofType type: T.Type) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            let results = realm.objects(type.self)
            try realm.write {
                realm.delete(results)
            }
        } catch {}
    }
    
    func convertToArray<T: Object>(list: List<T>) -> [T] {
        return list.map({ $0 })
    }
    
    func convertToList<T: Object>(array: [T]) -> List<T> {
        let list = List<T>()
        array.forEach { item in
            list.append(item)
        }
        return list
    }
    
    func updatePlan(item: PlanObject?, movieObject: MovieObject) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            
            if let planItem = item {
                try! realm.write({
                    for i in planItem.movies {
                        if i.id == movieObject.id && i.name == movieObject.name && i.title == movieObject.title {
                            i.isDone = true
                        }
                    }
                })
            } else {
                print("nill")
            }
            
        } catch {
            print("Error")
        }
    }
}
