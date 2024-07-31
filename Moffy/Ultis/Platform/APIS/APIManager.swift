import Foundation
import CryptoKit

class APIManager: NSObject {
  static let shared = APIManager()
  
    
  func getNowPlaying() async throws -> MovieResponse {
    guard let request = APIService.nowPlaying.request() else {
      throw APIError.invalidRequest
    }
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.invalidResponse
    }
    
    switch httpResponse.statusCode {
    case 200...299:
      break
    default:
      throw APIError.invalidResponse
    }
    
    let decodeData = try JSONDecoder().decode(MovieResponse.self, from: data)
    return decodeData
  }
  
    
    func getGenreMovie() async throws -> GenreResponse {
      guard let request = APIService.movieGenre.request() else {
        throw APIError.invalidRequest
      }
      let (data, response) = try await URLSession.shared.data(for: request)
      
      guard let httpResponse = response as? HTTPURLResponse else {
        throw APIError.invalidResponse
      }
      
      switch httpResponse.statusCode {
      case 200...299:
        break
      default:
        throw APIError.invalidResponse
      }
      
      let decodeData = try JSONDecoder().decode(GenreResponse.self, from: data)
      return decodeData
    }
    
    func getGenreTV() async throws -> GenreResponse {
      guard let request = APIService.tvGenre.request() else {
        throw APIError.invalidRequest
      }
      let (data, response) = try await URLSession.shared.data(for: request)
      
      guard let httpResponse = response as? HTTPURLResponse else {
        throw APIError.invalidResponse
      }
      
      switch httpResponse.statusCode {
      case 200...299:
        break
      default:
        throw APIError.invalidResponse
      }
      
      let decodeData = try JSONDecoder().decode(GenreResponse.self, from: data)
      return decodeData
    }
    
    func getMovieTopRate(_ page: Int) async throws -> MovieResponse {
        guard let request = APIService.topRateMovie(page: page).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
          throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
          break
        default:
          throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodeData
    }
    
    func getTVTopRate(_ page: Int) async throws -> MovieResponse {
        guard let request = APIService.topRateTvShow(page: page).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
          throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
          break
        default:
          throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodeData
    }
    
    func getMovieSearch(query: String, page: Int) async throws -> MovieResponse {
        guard let request = APIService.movieSearch(query: query, page: page).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
          throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
          break
        default:
          throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodeData
    }
    
    func getTvSearch(query: String, page: Int) async throws -> MovieResponse {
        guard let request = APIService.tvSearch(query: query, page: page).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
          throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
          break
        default:
          throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodeData
    }
    
    func getActorSearch(query: String, page: Int) async throws -> SearchActorResult {
        guard let request = APIService.actorSearch(query: query, page: page).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
          throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
          break
        default:
          throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(SearchActorResult.self, from: data)
        return decodeData
    }
    
    
    func getGenreIdMovie(genreId: String, page: Int) async throws -> MovieResponse {
        guard let request = APIService.genreId(genreID: genreId, page: page).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
          throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
          break
        default:
          throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodeData
    }
    
    func getMoviePopular(_ page: Int) async throws -> MovieResponse {
        guard let request = APIService.popularMovie(page: page).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        default:
            throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodeData
    }
    
    func getMovieUpComing(_ page: Int) async throws -> MovieResponse {
        guard let request = APIService.upComing(page: page).request() else {
            throw APIError.invalidRequest
        }
        let(data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        default:
            throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodeData
    }
    
    func getActorPopular(_ page: Int) async throws -> SearchActorResult {
        guard let request = APIService.polularActor(page: page).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        default:
            throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(SearchActorResult.self, from: data)
        return decodeData
    }
    
    func getActorDetail(_ personID: Int) async throws -> ActorDetail {
        guard let request = APIService.detailActor(personID: personID).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        default:
            throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(ActorDetail.self, from: data)
        return decodeData
    }
    
    func getTvShowPopular(_ page: Int) async throws -> MovieResponse {
        guard let request = APIService.popularTvShow(page: page).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        default:
            throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodeData
    }
    
    func getTvShowAiring(_ page: Int) async throws -> MovieResponse {
        guard let request = APIService.airingToday(page: page).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        default:
            throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodeData
    }
    
    func getTvShowGenreId(_ genreId: String, page: Int) async throws -> MovieResponse {
        guard let request = APIService.genreIdTvShow(genreID: genreId, page: page).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        default:
            throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodeData
    }
    
    func getmovieDetail(_ genreID: String) async throws -> MovieDetailModel {
        guard let request = APIService.movieDetail(genreID: genreID).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        default:
            throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(MovieDetailModel.self, from: data)
        return decodeData
    }
    
    func getTvDetail(_ genreID: String) async throws -> MovieDetailModel {
        guard let request = APIService.detailTvShow(genreID: genreID).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        default:
            throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(MovieDetailModel.self, from: data)
        return decodeData
    }
    
    func getEposodesList(_ idTV: String, _ seasonNumber: Int) async throws -> Eposides {
        guard let request = APIService.listEpisodeTvShow(idTV: idTV, seasonNumber: seasonNumber).request() else {
            throw APIError.invalidRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        default:
            throw APIError.invalidResponse
        }
        
        let decodeData = try JSONDecoder().decode(Eposides.self, from: data)
        return decodeData
    }
}
