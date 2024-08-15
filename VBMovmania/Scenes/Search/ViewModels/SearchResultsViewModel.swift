//
//  SearchResultsViewModel.swift
//  VBMovmania
//
//  Created by Suheda on 17.07.2024.
//

import Foundation

protocol SearchResultsViewModelProtocol {
    var view: SearchResultsViewControllerProtocol? {get set}
    
    func viewDidLoad()
    func reloadSearchResultCollection()
}

final class SearchResultsViewModel {
    weak var view: SearchResultsViewControllerProtocol?
    private let mediaService = MediaService()
    public var medias: [MediaResult] = []
    
    public func getMediaContent(indexPath: IndexPath, completion: @escaping ((title: String, description: String, videoKey: String, mediaType: String, mediaID: String)) -> Void) {
        let mediaID = String(medias[indexPath.item]._id)
        let mediaType: String = medias[indexPath.item]._mediaType
        let description = medias[indexPath.item]._overview
        var title = ""
        var videoID: String = ""
        
        switch mediaType {
        case "movie":
            title = medias[indexPath.item]._title
        case "tv":
            title = medias[indexPath.item]._name
        default:
            title = ""
        }
        
        mediaService.fetchVideo(with: Endpoint.fetchYoutubeVideoId(mediaType: mediaType, mediaID: mediaID)) { videos in
            for i in videos {
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

extension SearchResultsViewModel: SearchResultsViewModelProtocol {
    func reloadSearchResultCollection() {
        view?.reloadCollection()
    }
    
    func viewDidLoad() {
        view?.prepareCollectionView()
    }
}


