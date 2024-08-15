//
//  VideoModel.swift
//  VBMovmania
//
//  Created by Suheda on 15.07.2024.
//

import Foundation

struct VideoModel: Codable {
    let id: Int?
    let results: [VideoResult]
}

struct VideoResult: Codable {
    let name, key: String?
    let official: Bool?
    let type: String?
    let publishedAt: String?
    
    var _key: String {
        return key ?? ""
    }
    
    var _type: String {
        return type ?? ""
    }
    
    var _name: String {
        return name ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case name, key, official, type
        case publishedAt = "published_at"
    }
}
