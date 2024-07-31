//
//  PlanManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 21/02/2024.
//

import Foundation
import Combine

class PlanManager {
    static let shared = PlanManager()
    @Published var startDate: Date?
    @Published var endDate: Date?
//    @Published var namePlan: String?
//    @Published var notePlan: String?
    @Published var suggesPlan: [PlanItem] = []
    @Published var yourPlan: [PlanItem] = []
    @Published var randomSugestPlan: [PlanItem] = []
    @Published var topRateMovie: [Result] = []
    @Published var planDetail: PlanObject?
    @Published var planObject: [PlanObject]?
    @Published var movies = [MovieObject]()
    @Published var planSelected: [PlanObject] = []
    @Published var listDelete = [PlanObject]()
}

extension PlanManager {
    func createYourPlanDefault() {
        let movies = MovieTopRateManager.shared.cacheMovies
        let namePlan = "Example 1"
        let endDate = Date()
        let startDate = Date()
        let randomImage = getRandomImage(with: movies)
        
        let suggessPlan = PlanItem(namePlan: namePlan,
                                   movies: movies,
                                   endDate: endDate,
                                   startDate: startDate,
                                   image: randomImage)
        
        self.suggesPlan.append(suggessPlan)
        
        let planObject = PlanObject(with: suggessPlan)
        RealmService.shared.add(planObject)
    }
    
    func createYourPlan(namePlan: String, startDate: Date?, endDate: Date?, note: String) {
        let movies = MovieTopRateManager.shared.movieDefaultRealm
        let namePlan = namePlan
        let startDate = startDate
        let endDate = endDate
        let note = note
        let randomImage = MovieTopRateManager.shared.cacheCoverPlan
        
        let yourPlan = PlanItem(namePlan: namePlan,
                                movies: movies,
                                endDate: endDate,
                                startDate: startDate,
                                image: randomImage,
                                note: note)
        let planObject = PlanObject(with: yourPlan)
        RealmService.shared.add(planObject)
    }
    
    func updateYourPlan(plan: PlanObject?, image: String, namePlan: String, startDate: Date?, endDate: Date?, note: String, movies: [MovieObject]?) {
        if let planId = plan?.id, let existingPlan = RealmService.shared.getById(ofType: PlanObject.self, id: planId) {
            let newData: [String: Any] = [
                "namePlan": namePlan,
                "startDate": startDate ?? existingPlan.startDate,
                "endDate": endDate ?? existingPlan.endDate,
                "note": note,
                "image": image.isEmpty ? existingPlan.image : image,
                "movies": movies ?? Array(existingPlan.movies)
            ]
            RealmService.shared.update(existingPlan, data: newData)
        }
    }
    
    func createPlanForWeekend() {
        //  lấy 2 phần tử ngẫu nhiên của movieObject
        let genreChoose = RealmService.shared.fetch(ofType: MovieGenreObject.self)
        let randomGenre = Array(genreChoose.shuffled().prefix(2))
        let randomGenreId1 = randomGenre[0].id
        let randomGenreId2 = randomGenre[1].id
        
        let nameGenre1 = MovieGenreManager.shared.getGenreName(with: randomGenreId1)
        let nameGenre2 = MovieGenreManager.shared.getGenreName(with: randomGenreId2)
        let nameGenre = "\(nameGenre1)/\(nameGenre2)"
        // lấy 3 phần tử trong movietoprate có genreid trùng với randomGenreId1 hoặc randomGenreId2
        let moviesWithRandomGenre = MovieTopRateManager.shared.topRateMovie.filter { movie in
            guard let genreIds = movie.genreIDS else { return false }
            return genreIds.contains(randomGenreId1) || genreIds.contains(randomGenreId2)
        }
        
        let threeRandomMovies = Array(moviesWithRandomGenre.prefix(3))
        let randomImage = threeRandomMovies.randomElement()?.backdropPath ?? ""
        let movies = convertToMovieObjects(results: threeRandomMovies)
        
        let planForWeekend = PlanItem(namePlan: "Plan for the weekend",
                                   movies: movies,
                                   endDate: Date(),
                                   startDate: Date(),
                                   generPlan: nameGenre,
                                   image: randomImage)
        
        let planObject = PlanSuggestObject(with: planForWeekend)
        RealmService.shared.add(planObject)
    }
    
    func createPlanForGenre() {
        let genreChoose = RealmService.shared.fetch(ofType: MovieGenreObject.self)
        let randomGenre = Array(genreChoose.shuffled().prefix(2))
        let randomGenreId1 = randomGenre[0].id
        let randomGenreId2 = randomGenre[1].id
        
        let nameGenre1 = MovieGenreManager.shared.getGenreName(with: randomGenreId1)
        let nameGenre2 = MovieGenreManager.shared.getGenreName(with: randomGenreId2)
        let nameGenre = "\(nameGenre1)/\(nameGenre2)"
        
        let randomIndex = Int.random(in: 0..<2)
        let genreId = randomGenre[randomIndex].id
        let nameGenrePlan = MovieGenreManager.shared.getGenreName(with: genreId)
        let moviesWithRandomGenre = MovieTopRateManager.shared.topRateMovie.filter { movie in
            guard let genreIds = movie.genreIDS else { return false }
            return genreIds.contains(genreId)
        }
        
        let threeRandomMovies = Array(moviesWithRandomGenre.prefix(3))
        let randomImage = threeRandomMovies.randomElement()?.backdropPath ?? ""
        let movies = convertToMovieObjects(results: threeRandomMovies)
        
        let planForGenre = PlanItem(namePlan: "\(nameGenrePlan) plan",
                                   movies: movies,
                                   endDate: Date(),
                                   startDate: Date(),
                                   generPlan: nameGenre,
                                   image: randomImage)
        
        self.randomSugestPlan.append(planForGenre)
        let planObject = PlanSuggestObject(with: planForGenre)
        RealmService.shared.add(planObject)
    }
    
    func createNameMoviePlan() {
        // random 3 bộ phim trong catch, lấy ra 3 id của 3 bộ phim đó
        let genreChoose = MovieTopRateManager.shared.cacheMovies
        let shuffleGenreChoose = Array(genreChoose.shuffled())
        var randomGenreId1: Int = -1
        var randomGenreId2: Int = -1

        for item in shuffleGenreChoose {
            if item.genreIds.count >= 2 {
                let randomGenre = Array(item.genreIds.shuffled().prefix(2))
                randomGenreId1 = randomGenre[0]
                randomGenreId2 = randomGenre[1]
                break
            }
        }
        
        let nameGenre1 = MovieGenreManager.shared.getGenreName(with: randomGenreId1)
        let nameGenre2 = MovieGenreManager.shared.getGenreName(with: randomGenreId2)
        let nameGenre = "\(nameGenre1)/\(nameGenre2)"
        
        let nameGenrePlan = shuffleGenreChoose[0].title ?? shuffleGenreChoose[0].name
        
        let moviesWithRandomGenre = MovieTopRateManager.shared.topRateMovie.filter { movie in
            guard let genreIds = movie.genreIDS else { return false }
            return genreIds.contains(randomGenreId1) || genreIds.contains(randomGenreId2)
        }
        
        let threeRandomMovies = Array(moviesWithRandomGenre.prefix(3))
        let randomImage = threeRandomMovies.randomElement()?.backdropPath ?? ""
        let movies = convertToMovieObjects(results: threeRandomMovies)
        
        let nameMoviePlan = PlanItem(namePlan: "\(nameGenrePlan ?? "") plan",
                                   movies: movies,
                                   endDate: Date(),
                                   startDate: Date(),
                                   generPlan: nameGenre,
                                   image: randomImage)
        
        self.randomSugestPlan.append(nameMoviePlan)
        let planObject = PlanSuggestObject(with: nameMoviePlan)
        RealmService.shared.add(planObject)
        
    }
    
    func getRandomMovies(with movieObjects: [MovieObject]) -> [MovieObject] {
        var randomMovies: [MovieObject] = []
        let shuffledMovies = movieObjects.shuffled()
        let count = min(3, shuffledMovies.count)
        
        for i in 0..<count {
            let movieToAdd = shuffledMovies[i]
            if !randomMovies.contains(where: { $0.name == movieToAdd.name }) {
                randomMovies.append(movieToAdd)
            }
        }
        
        return randomMovies
    }
    
    func getRandomImage(with movieObjects: [MovieObject]) -> String? {
        let movieImage = movieObjects.map { $0.posterPath}
        
        return movieImage.randomElement() ?? ""
    }
    
    func convertToMovieObjects(results: [Result]) -> [MovieObject] {
        var movieObjects: [MovieObject] = []
        for result in results {
            let movieObject = MovieObject()
            movieObject.title = result.title ?? ""
            movieObject.idMovie = result.id ?? 0
            movieObject.name = result.name
            movieObject.overview = result.overview ?? ""
            movieObject.posterPath = result.posterPath ?? ""
            movieObject.releaseDate = result.releaseDate ?? ""
            movieObject.voteAverage = result.voteAverage ?? 0.0
            movieObject.voteCount = result.voteCount ?? 0
            movieObject.adult = result.adult ?? false
            movieObject.backdropPath = result.backdropPath ?? ""
            movieObject.video = result.video ?? false
            movieObject.popularity = result.popularity ?? 0.0
            movieObject.firstAirDate = result.firstAirDate ?? ""
            
            if let genreIds = result.genreIDS {
                for genreId in genreIds {
                    movieObject.genreIds.append(genreId)
                }
            }
            movieObjects.append(movieObject)
        }
        return movieObjects
    }
}

extension PlanManager {
    func setDoneMovie(with movieObject: MovieObject, plan: PlanObject) {
        let planItem = RealmService.shared.getById(ofType: PlanObject.self, id: plan.id)
        RealmService.shared.updatePlan(item: planItem, movieObject: movieObject)
    }
    
    func savePlanSelected(with planSelected: PlanObject) {
        if !self.planSelected.contains(where: {$0.id == planSelected.id}) {
            self.planSelected.append(planSelected)
            self.listDelete.removeAll(where: {$0.id == planSelected.id})
        } else {
            self.planSelected.removeAll(where: {$0.id == planSelected.id})
            self.listDelete.append(planSelected)
        }
    }
}
