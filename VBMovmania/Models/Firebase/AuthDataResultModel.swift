//
//  AuthDataResultModel.swift
//  VBMovmania
//
//  Created by Suheda on 21.07.2024.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}
