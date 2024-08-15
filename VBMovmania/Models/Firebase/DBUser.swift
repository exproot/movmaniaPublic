//
//  DBUser.swift
//  VBMovmania
//
//  Created by Suheda on 21.07.2024.
//

import Foundation

struct DBUser: Codable{
    let userId: String
    let email: String?
    let dataCreated: Date?
    
    var _email: String {
        return email ?? ""
    }
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.dataCreated = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case dataCreated = "date_created"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.dataCreated = try container.decodeIfPresent(Date.self, forKey: .dataCreated)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.dataCreated, forKey: .dataCreated)
    }
}
