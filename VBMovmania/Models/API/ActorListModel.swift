//
//  ActorListModel.swift
//  VBMovmania
//
//  Created by Suheda on 25.07.2024.
//

import Foundation

struct ActorListModel: Codable {
    let page: Int?
    let results: [PopActor]
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct PopActor: Codable {
    let id: Int?
    let name: String?
    let popularity: Double?
    let profilePath: String?
    
    var _id: Int {
        return id ?? Int.min
    }
    
    var _name: String {
        return name ?? ""
    }
    
    var _profilePath: String {
        return profilePath ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case popularity
        case profilePath = "profile_path"
    }
}
