//
//  Endpoint.swift
//  VBMovmania
//
//  Created by Suheda on 17.07.2024.
//

import Foundation

enum Endpoint {
    case fetchPopulars(url: String = "/3/", mediaType: String = "movie", language: String = "en-US")
    case fetchUpcomingMovies(url: String = "/3/movie/upcoming")
    case fetchTrendingWeekly(url: String = "/3/trending/all/week")
    case fetchTrendingDaily(url: String = "/3/trending/all/day")
    case fetchDiscoverMovies(url: String = "/3/discover/movie", sortBy: String = "vote_count.desc")
    case fetchDiscoverMoviesFilterByVoteCount(url: String = "/3/discover/movie", sortBy: String = "vote_count.desc", voteCountGreaterThan: String)
    case fetchSearchMovies(url: String = "/3/search/multi", query: String = "")
    case fetchYoutubeVideoId(url: String = "/3/", mediaType: String = "movie", mediaID: String = "" )
    case fetchRecommendations(url: String = "/3/", mediaType: String = "movie", mediaID: String = "" )
    case fetchCast(url: String = "/3/", mediaType: String = "movie", mediaID: String = "")
    case fetchDetails(url: String = "/3/", mediaType: String = "movie", mediaID: String)
    case fetchActorDetails(url: String = "/3/person", actorID: String)
    case fetchActorCredits(url: String = "/3/person", actorID: String)
    case fetchPopularActors(url: String = "/3/person")
    
    var request: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.httpBody = self.httpBody
        return request
    }
    
    private var url: URL? {
        var components = URLComponents()
        components.scheme =  Constants.scheme //https
        components.host = Constants.baseURL //api.themoviedb.org
        components.port = Constants.port // nil
        components.path = self.path //i.e: /3/upcoming
        components.queryItems = self.queryItems //i.e: language=en-US&page=1&api_key=KEY
        return components.url //i.e: https://api.themoviedb.org/3/upcoming?language=en-US&page=1&api_key=KEY
    }
    
    
    
    private var path: String {
        switch self {
        case .fetchUpcomingMovies(let url),
                .fetchTrendingWeekly(let url),
                .fetchTrendingDaily(let url),
                .fetchDiscoverMovies(let url, _),
                .fetchDiscoverMoviesFilterByVoteCount(let url, _, _),
                .fetchSearchMovies(let url, _):
            return url
        case .fetchPopulars(let url, let mediaType, _):
            return "\(url)\(mediaType)/popular"
        case .fetchYoutubeVideoId(let url, let mediaType, let mediaID):
            return "\(url)\(mediaType)/\(mediaID)/videos"
        case .fetchRecommendations(let url, let mediaType, let mediaID):
            return "\(url)\(mediaType)/\(mediaID)/recommendations"
        case .fetchCast(let url, let mediaType, let mediaID):
            return "\(url)\(mediaType)/\(mediaID)/credits"
        case .fetchDetails(let url, let mediaType, let mediaID):
            return "\(url)\(mediaType)/\(mediaID)"
        case .fetchActorDetails(let url, let actorID):
            return "\(url)/\(actorID)"
        case .fetchActorCredits(let url, let actorID):
            return "\(url)/\(actorID)/combined_credits"
        case .fetchPopularActors(let url):
            return "\(url)/popular"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .fetchPopulars(_, _, let language):
            return [
                URLQueryItem(name: "language", value: language),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "api_key", value: Constants.API_KEY)
            ]
        case .fetchUpcomingMovies:
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "region", value: "US"),
                URLQueryItem(name: "api_key", value: Constants.API_KEY)
            ]
        case .fetchTrendingWeekly:
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "api_key", value: Constants.API_KEY)
            ]
        case .fetchTrendingDaily:
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "api_key", value: Constants.API_KEY)
            ]
        case .fetchDiscoverMovies(_, let sortBy):
            return [
                URLQueryItem(name: "sort_by", value: sortBy),
                URLQueryItem(name: "include_adult", value: "false"),
                URLQueryItem(name: "include_video", value: "false"),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "api_key", value: Constants.API_KEY)
            ]
        case .fetchDiscoverMoviesFilterByVoteCount(_, let sortBy, let voteCountGreaterThan):
            return [
                URLQueryItem(name: "vote_count.gte", value: voteCountGreaterThan),
                URLQueryItem(name: "sort_by", value: sortBy),
                URLQueryItem(name: "include_adult", value: "false"),
                URLQueryItem(name: "include_video", value: "false"),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "api_key", value: Constants.API_KEY)
            ]
        case .fetchSearchMovies(_, let query):
            return [
                URLQueryItem(name: "query", value: query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)),
                URLQueryItem(name: "include_adult", value: "false"),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "api_key", value: Constants.API_KEY)
            ]
        case .fetchYoutubeVideoId(_, _, _):
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "api_key", value: Constants.API_KEY)
            ]
        case .fetchRecommendations(_, _, _):
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "api_key", value: Constants.API_KEY)
            ]
        case .fetchCast(_, _, _):
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "api_key", value: Constants.API_KEY)
            ]
        case .fetchDetails(_, _, _):
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "api_key", value: Constants.API_KEY)
            ]
        case .fetchActorDetails(_, _):
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "api_key", value: Constants.API_KEY)
            ]
        case .fetchActorCredits(_, _):
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "api_key", value: Constants.API_KEY)
            ]
        case .fetchPopularActors:
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "api_key", value: Constants.API_KEY)
            ]
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .fetchPopulars,
                .fetchUpcomingMovies,
                .fetchTrendingWeekly,
                .fetchTrendingDaily,
                .fetchDiscoverMovies,
                .fetchDiscoverMoviesFilterByVoteCount,
                .fetchSearchMovies,
                .fetchYoutubeVideoId,
                .fetchRecommendations,
                .fetchCast,
                .fetchDetails,
                .fetchActorDetails,
                .fetchActorCredits,
                .fetchPopularActors:
            HTTP.Method.get.rawValue
        }
    }
    
    private var httpBody: Data? {
        switch self {
        case .fetchPopulars,
                .fetchUpcomingMovies,
                .fetchTrendingWeekly,
                .fetchTrendingDaily,
                .fetchDiscoverMovies,
                .fetchDiscoverMoviesFilterByVoteCount,
                .fetchSearchMovies,
                .fetchYoutubeVideoId,
                .fetchRecommendations,
                .fetchCast,
                .fetchDetails,
                .fetchActorDetails,
                .fetchActorCredits,
                .fetchPopularActors:
            return nil
        }
    }
}
