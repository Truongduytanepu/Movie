//
//  APIService.swift
//  Moffy
//
//  Created by Trương Duy Tân on 31/01/2024.
//

import Foundation


import Foundation

enum APIService {
    case nowPlaying
    case topRateMovie(page: Int)
    case popularMovie(page: Int)
    case upComing(page: Int)
    case genreId(genreID: String, page: Int)
    case movieDetail(genreID: String)
    case airingToday(page: Int)
    case popularTvShow(page: Int)
    case topRateTvShow(page: Int)
    case detailTvShow(genreID: String)
    case polularActor(page: Int)
    case detailActor(personID: Int)
    case movieGenre
    case tvGenre
    case movieSearch(query: String, page: Int)
    case tvSearch(query: String, page: Int)
    case actorSearch(query: String, page: Int)
    case genreIdTvShow(genreID: String, page: Int)
    case listEpisodeTvShow(idTV: String, seasonNumber: Int)
    case detailEpisode
    
    var domain: String {
        switch self {
        default:
            return URLs.domain
        }
    }
    
    var path: String? {
        switch self {
        case .nowPlaying:
            return "3/movie/now_playing?api_key=dc9e9a73378330417bb4818abf1b60ed&page=2"
        case .topRateMovie:
            return "/3/movie/top_rated"
        case .popularMovie:
            return "/3/movie/popular"
        case .upComing:
            return "/3/movie/upcoming"
        case .genreId:
            return "/3/discover/movie"
        case .movieDetail(let genreID):
            return "/3/movie/\(genreID)"
        case .airingToday:
            return "/3/tv/airing_today"
        case .popularTvShow:
            return "/3/tv/popular"
        case .topRateTvShow:
            return "/3/tv/top_rated"
        case .detailTvShow(let genreID):
            return "/3/tv/\(genreID)"
        case .polularActor:
            return "/3/person/popular"
        case .detailActor(let personID):
            return "/3/person/\(personID)"
        case .movieGenre:
            return "/3/genre/movie/list"
        case .tvGenre:
            return "/3/genre/tv/list"
        case .movieSearch:
            return "/3/search/movie"
        case .tvSearch:
            return "/3/search/tv"
        case .actorSearch:
            return "/3/search/person"
        case .listEpisodeTvShow(let idTV, let seasonNumber):
            return "/3/tv/\(idTV)/season/\(seasonNumber)"
        case .detailEpisode:
            return "/3/tv/100/season/1/episode/2?api_key=e488fbfea7bb2a2ae5b43d4e1861543c"
        case .genreIdTvShow:
            return "/3/discover/tv"
        }
    }
    
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    var params: [String: String?] {
        var params: [String: String?] = [:]
        switch self {
        case .movieGenre, .tvGenre, .listEpisodeTvShow:
            params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
        case .polularActor(let page):
            params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
            params["page"] = "\(page)"
        case .topRateMovie(let page), .popularTvShow(let page), .airingToday(let page):
            params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
            params["page"] = "\(page)"
        case .popularMovie(let page):
            params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
            params["page"] = "\(page)"
        case .topRateTvShow(let page):
            params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
            params["page"] = "\(page)"
        case .genreId(let genreID, let page):
            params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
            params["with_genres"] = genreID
            params["page"] = "\(page)"
        case .genreIdTvShow(let genreID, let page):
            params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
            params["with_genres"] = genreID
            params["page"] = "\(page)"
        case .movieSearch(let query, let page), .tvSearch(let query, let page):
            params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
            params["query"] = query
            params["page"] = "\(page)"
        case .actorSearch(let query, let page):
            params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
            params["query"] = query
            params["page"] = "\(page)"
        case .upComing(let page):
            params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
            params["with_genres"] = "12"
            params["page"] = "\(page)"
        case .detailActor:
            params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
            params["append_to_response"] = "movie_credits,images,tv_credits"
        case .movieDetail:
            params["api_key"] = "dc9e9a73378330417bb4818abf1b60ed"
            params["append_to_response"] = "videos,credits,recommendations,reviews"
        case .detailTvShow:
            params["api_key"] = "de388d928806ca4a66b2807512c32084"
            params["append_to_response"] = "videos,credits,recommendations,images"
        default:
            break
        }
        return params
    }
    
    var headers: [String: String?] {
        var headers: [String: String?] = [:]
        switch self {
        default:
            headers["Content-Type"] = "application/json"
        }
        return headers
    }
}

extension APIService {
    func request(body: Data? = nil) -> URLRequest? {
        guard
            let url = URL(string: domain),
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            return nil
        }
        if let path {
            urlComponents.path = path
        }
        urlComponents.queryItems = params.map({
            return URLQueryItem(name: $0, value: $1)
        })
        
        guard let urlRequest = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: urlRequest)
        request.httpMethod = method
//        print(urlRequest)
        
        headers.forEach {
            request.setValue($1, forHTTPHeaderField: $0)
        }
        
        if let body {
            request.httpBody = body
        }
        
        return request
    }
}


