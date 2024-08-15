//
//  CastModel.swift
//  VBMovmania
//
//  Created by Suheda on 18.07.2024.
//

import Foundation

struct CastModel: Codable {
    let id: Int?
    let cast: [Cast]
}

struct Cast: Codable {
    let id: Int?
    let name: String?
    let profilePath: String?
    let character: String?
    let birthday: String?
    let placeOfBirth: String?
    let biography: String?
    
    var _id: Int {
        return id ?? Int.min
    }
    
    var _profilePath: String {
        return profilePath ?? ""
    }
    
    var _name: String {
        return name ?? ""
    }
    
    var _biography: String {
        return biography ?? ""
    }
    
    var _character: String {
        return character ?? ""
    }
    
    var _birthday: String {
        return birthday ?? ""
    }
    
    var _placeOfBirth: String {
        return placeOfBirth ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case biography
        case profilePath = "profile_path"
        case character
        case birthday
        case placeOfBirth = "place_of_birth"
    }
}
