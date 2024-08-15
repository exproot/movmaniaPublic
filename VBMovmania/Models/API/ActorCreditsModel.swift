//
//  ActorCreditsModel.swift
//  VBMovmania
//
//  Created by Suheda on 25.07.2024.
//

import Foundation

struct ActorCreditsModel: Codable {
    let cast: [AsCast]
    let id: Int?
}

struct AsCast: Codable {
    let id: Int?
    let overview: String?
    let posterPath, releaseDate, title: String?
    let voteAverage: Double?
    let voteCount: Int?
    let character: String?
    let mediaType: String?
    let name: String?
    
    var _id: Int {
        return id ?? Int.min
    }
    
    var _title: String {
        return title ?? ""
    }
    
    var _name: String {
        return name ?? ""
    }
    
    var _mediaType: String {
        return mediaType ?? ""
    }
    
    var _overview: String {
        return overview ?? ""
    }
    
    var _posterPath: String {
        return posterPath ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case character
        case mediaType = "media_type"
        case name
    }
}
