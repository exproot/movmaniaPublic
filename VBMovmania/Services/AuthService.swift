//
//  AuthService.swift
//  VBMovmania
//
//  Created by Suheda on 21.07.2024.
//

import Foundation
import FirebaseAuth

final class AuthService {
    static let shared = AuthService()
    
    private init() {}
    
    func resetPassword(with email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    func signOut(completion: @escaping (Error?) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func signIn(with email: String, and password: String, completion: @escaping (Result<AuthDataResultModel, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            completion(.success(AuthDataResultModel(user: user)))
        }
    }
    
    func createUser(with email: String, and password: String, completion: @escaping (Result<AuthDataResultModel, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            completion(.success(AuthDataResultModel(user: user)))
        }
    }
}
