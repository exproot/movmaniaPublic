//
//  HomeTableCellViewModel.swift
//  VBMovmania
//
//  Created by Suheda on 17.07.2024.
//

import Foundation

protocol HomeTableCellViewModelProtocol {
    var view: HomeTableCellProtocol? {get set}
    
    func cellDidLoad()
    func setTableCell(with media: [MediaResult])
}

final class HomeTableCellViewModel {
    weak var view: HomeTableCellProtocol?
    private let mediaService = MediaService()
    public var media: [MediaResult] = []
    
    public func getYoutubeVideoKey(indexPath: IndexPath, completion: @escaping ((title: String, description: String, videoID: String, mediaType: String, mediaID: String)) -> Void) {
        let mediaID =  String(media[indexPath.item]._id)
        var mediaType: String = "movie"
        var title: String = ""
        let description: String = media[indexPath.item]._overview
        var videoID: String = ""
        
        if media[indexPath.item].name != nil {
            mediaType = "tv"
            title = media[indexPath.item]._name
        } else {
            mediaType = "movie"
            title = media[indexPath.item]._title
        }
        
        mediaService.fetchVideo(with: Endpoint.fetchYoutubeVideoId(mediaType: mediaType, mediaID: mediaID)) { videos in
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
            completion((title, description, videoID, mediaType, mediaID))
        }
    }
}

extension HomeTableCellViewModel: HomeTableCellViewModelProtocol {
    public func setTableCell(with media: [MediaResult]) {
        DispatchQueue.main.async { [weak self] in
            self?.media = media
            self?.view?.reloadCollection()
        }
    }
    
    func cellDidLoad() {
        view?.prepareCollectionView()
    }
}
