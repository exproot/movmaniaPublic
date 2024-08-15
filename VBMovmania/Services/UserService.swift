//
//  UserService.swift
//  VBMovmania
//
//  Created by Suheda on 21.07.2024.
//

import Foundation
import FirebaseFirestore

final class UserService {
    static let shared = UserService()
    private let mediaService = MediaService()
    
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        return userCollection.document(userId)
    }
    public func userFavoriteMediaCollection(userId: String) -> CollectionReference {
        return userDocument(userId: userId).collection("favorite_medias")
    }
    private func userFavoriteMediaDocument(userId: String, movieId: String) -> DocumentReference {
        return userFavoriteMediaCollection(userId: userId).document(movieId)
    }
    
    func removeFavorite(userId: String, mediaId: String) {
        userFavoriteMediaDocument(userId: userId, movieId: mediaId).delete { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("media deleted successfully")
        }
    }
    
    func addFavorite(userId: String, mediaId: String, mediaType: String) {
        let document = userFavoriteMediaDocument(userId: userId, movieId: mediaId)
        let data: [String: Any] = [
            "id" : mediaId,
            "media_type" : mediaType,
            "date_created" : Timestamp()
        ]
        
        document.setData(data, merge: false) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("media added successfully")
        }
    }
    
    func getUserData(userId: String, completion: @escaping (DBUser?) -> Void) {
        userDocument(userId: userId).getDocument(as: DBUser.self) { result in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func saveNewUser(user: DBUser) {
        do {
            try userDocument(userId: user.userId).setData(from: user, encoder: Firestore.Encoder()) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
