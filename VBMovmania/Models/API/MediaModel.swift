//
//  MovieModel.swift
//  VBMovmania
//
//  Created by Suheda on 13.07.2024.
//

import Foundation

struct MediaModel: Codable {
    let page: Int?
    let results: [MediaResult]
}

struct MediaResult: Codable {
    let id: Int?
    let overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let voteAverage: Double?
    let voteCount: Int?
    let mediaType: String?
    let name: String?
    let genres: [MediaGenre]?
    
    var _id: Int {
        return id ?? Int.min
    }
    
    var _posterPath: String {
        return posterPath ?? ""
    }
    
    var _title: String {
        return title ?? ""
    }
    
    var _name: String {
        return name ?? ""
    }
    
    var _overview: String {
        return overview ?? ""
    }
    
    var _mediaType: String {
        return mediaType ?? ""
    }
    
    var _voteAverage: Double {
        return voteAverage ?? 0
    }
    
    var _voteCount: Int {
        return voteCount ?? 0
    }

    enum CodingKeys: String, CodingKey {
        case id
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case mediaType = "media_type"
        case genres
    }
}

struct MediaGenre: Codable {
    let id: Int?
    let name: String?
    
    var _name: String {
        return name ?? ""
    }
}
