//
//  FavoritesViewModel.swift
//  VBMovmania
//
//  Created by Suheda on 24.07.2024.
//

import Foundation
import FirebaseAuth

protocol FavoritesViewModelProtocol {
    var view: FavoritesViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func getYoutubeVideoKey(indexPath: IndexPath)
    func getMediaContentForCell(indexPath: IndexPath) -> ((path: String, name: String, desc: String, rating: String, voteCount: String))
    func removeFromFavorites(indexPath: IndexPath)
}

final class FavoritesViewModel {
    weak var view: FavoritesViewControllerProtocol?
    private var user: User?
    private let mediaService = MediaService()
    var medias: [MediaResult] = []
    
    private func fetchCurrentUser() {
        guard let user = Auth.auth().currentUser else { return }
        self.user = user
    }
    
    private func fetchFavoriteMedias() {
        guard let user = self.user else { return }
        UserService.shared.userFavoriteMediaCollection(userId: user.uid).addSnapshotListener {
            [weak self] snapshot, error in
            self?.medias.removeAll()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {
                return
            }
            
            if snapshot.documents.count > 0 {
                
                for document in snapshot.documents {
                    var mediaType: String = ""
                    for i in document.data() {
                        if i.key == "media_type" {
                            mediaType = i.value as? String ?? ""
                        }
                    }
                    self?.mediaService.fetchMedia(with: Endpoint.fetchDetails(mediaType: mediaType, mediaID: document.documentID)) { media in
                        print("api called.")
                        self?.medias.append(media)
                        self?.view?.reloadTable()
                    }
                }
            } else {
                self?.view?.reloadTable()
            }
            
        }
    }
}

extension FavoritesViewModel: FavoritesViewModelProtocol {
    func removeFromFavorites(indexPath: IndexPath) {
        guard let user = self.user else { return }
        UserService.shared.removeFavorite(userId: user.uid, mediaId: String(self.medias[indexPath.row]._id))
        self.medias.remove(at: indexPath.row)
        view?.reloadTable()
    }
    
    func getMediaContentForCell(indexPath: IndexPath) -> ((path: String, name: String, desc: String, rating: String, voteCount: String)) {
        let path = self.medias[indexPath.row]._posterPath
        var name: String!
        if let title = self.medias[indexPath.row].title {
            name = title
        }else {
            name = self.medias[indexPath.row]._name
        }
        let desc = self.medias[indexPath.row]._overview
        let average = String(round(10 * self.medias[indexPath.row]._voteAverage) / 10)
        let votes = String(self.medias[indexPath.row]._voteCount)
        let rating = "\(average)/10"
        
        return ((path, name, desc, rating, votes))
    }
    
    func getYoutubeVideoKey(indexPath: IndexPath) {
        let mediaID =  String(medias[indexPath.item]._id)
        var mediaType: String = "movie"
        var title: String = ""
        let description: String = medias[indexPath.item]._overview
        var videoID: String = ""
        
        if medias[indexPath.item].name != nil {
            mediaType = "tv"
            title = medias[indexPath.item]._name
        } else {
            mediaType = "movie"
            title = medias[indexPath.item]._title
        }
        
        mediaService.fetchVideo(with: Endpoint.fetchYoutubeVideoId(mediaType: mediaType, mediaID: mediaID)) { [weak self] videos in
            for i  in videos {
                if i._type == "Trailer" {
                    videoID = i._key
                    break
                } else if videoID == "" && i._type == "Teaser" {
                    videoID = i._key
                } else if videoID == "" && i._type == "Clip" {
                    videoID = i._key
                } else {
                    videoID = i._key
                }
            }
            self?.view?.navigateToDetails(title: title, description: description, videoKey: videoID, mediaType: mediaType, mediaID: mediaID)
        }
    }
    
    func viewDidLoad() {
        view?.prepareNavBar()
        view?.prepareTableView()
        self.fetchCurrentUser()
        self.fetchFavoriteMedias()
    }
}
