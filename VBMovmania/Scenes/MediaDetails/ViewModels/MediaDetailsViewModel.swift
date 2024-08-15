//
//  MediaDetailsViewModel.swift
//  VBMovmania
//
//  Created by Suheda on 24.07.2024.
//

import Foundation
import FirebaseAuth

protocol MediaDetailsViewModelProtocol {
    var view: MediaDetailsViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func viewWillAppear()
    func getActors(mediaType: String, mediaID: String)
    func getRecommendations(mediaType: String, mediaID: String)
    func handleTapAddToFavoritesButton()
    func getContentForMediaDetails(indexPath: IndexPath, completion: @escaping ((title: String, desc: String, videoID: String, mediaType: String, mediaID: String)) -> ())
}

final class MediaDetailsViewModel {
    weak var view: MediaDetailsViewControllerProtocol?
    private var user: User?
    private let mediaService = MediaService()
    private var isFavorite: Bool = false
    var mediaId: String?
    var mediaType: String?
    var actors: [Cast] = []
    var recommended: [MediaResult] = []
    
    private func checkFavorites() {
        guard let user = user else { return }
        UserService.shared.userFavoriteMediaCollection(userId: user.uid).addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            guard let mediaId = mediaId else { return }
            guard let snapshot = snapshot else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let ids = snapshot.documents.map {  $0.documentID }
            
            self.isFavorite = ids.contains(mediaId) ? true : false
            
            if self.isFavorite {
                self.view?.setButtonUIToAddFavorites()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.view?.setButtonUIToAddFavorites()
                }
            }else {
                self.view?.setButtonUIToRemoveFavorites()
            }
        }
    }
}

extension MediaDetailsViewModel: MediaDetailsViewModelProtocol {
    func getContentForMediaDetails(indexPath: IndexPath, completion: @escaping ((title: String, desc: String, videoID: String, mediaType: String, mediaID: String)) -> ()) {
        let mediaId = String(recommended[indexPath.item]._id)
        let mediaType = recommended[indexPath.item]._mediaType
        let description = recommended[indexPath.item]._overview
        var title = ""
        switch mediaType {
        case "movie":
            title = recommended[indexPath.item]._title
        case "tv":
            title = recommended[indexPath.item]._name
        default:
            title = ""
        }
        var videoId: String = ""
        
        mediaService.fetchVideo(with: Endpoint.fetchYoutubeVideoId(mediaType: mediaType, mediaID: mediaId)) { videos in
            for i in videos {
                if i._type == "Trailer" {
                    videoId = i._key
                    break
                } else if videoId == "" && i._type == "Teaser" {
                    videoId = i._key
                } else if videoId == "" && i._type == "Clip" {
                    videoId = i._key
                } else {
                    videoId = i._key
                }
            }
            completion((title, description, videoId, mediaType, mediaId))
        }
    }
    
    func viewWillAppear() {
        self.checkFavorites()
    }
    
    func handleTapAddToFavoritesButton() {
        guard let user = self.user else { return }
        guard let mediaId = self.mediaId else { return }
        guard let mediaType = self.mediaType else { return }
        
        if !isFavorite {
            view?.changeUIAddingFavorite()
            view?.startHeartAnimation()
            UserService.shared.addFavorite(userId: user.uid, mediaId: mediaId, mediaType: mediaType)
            isFavorite = true
        }else {
            UserService.shared.removeFavorite(userId: user.uid, mediaId: mediaId)
            isFavorite = false
        }
    }
    
    func getRecommendations(mediaType: String, mediaID: String) {
        mediaService.fetchMedias(with: Endpoint.fetchRecommendations(mediaType: mediaType, mediaID: mediaID)) { [weak self] recommendations in
            self?.recommended = recommendations
            self?.view?.reloadRecommendations()
        }
    }
    
    func getActors(mediaType: String, mediaID: String) {
        mediaService.fetchCast(with: Endpoint.fetchCast(mediaType: mediaType, mediaID: mediaID)) { [weak self] actors in
            self?.actors = actors
            self?.view?.reloadActors()
        }
    }
    
    func viewDidLoad() {
        self.user = Auth.auth().currentUser
        view?.prepareCollectionView()
        view?.prepareScrollView()
        view?.prepareLabels()
        view?.prepareTrailerView()
        view?.prepareLoadingView()
        view?.prepareNoTrailersView()
        view?.prepareButtons()
    }
}
