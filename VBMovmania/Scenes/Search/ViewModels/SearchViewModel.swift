//
//  SearchViewModel.swift
//  VBMovmania
//
//  Created by Suheda on 17.07.2024.
//

import Foundation

protocol SearchViewModelProtocol {
    var view: SearchViewControllerProtocol? {get set}
    
    func viewDidLoad()
    func fetchMovies(sortBy: String, voteCountGreaterThan: String?)
}

final class SearchViewModel {
    weak var view: SearchViewControllerProtocol?
    private let mediaService = MediaService()
    public var movies: [MediaResult] = []
    public var popularActors: [PopActor] = []
    
    private func fetchPopularActors() {
        mediaService.fetchPopularActors(with: Endpoint.fetchPopularActors()) { [weak self] actors in
            self?.popularActors = actors
            self?.view?.reloadCollection()
        }
    }
    
    public func getMediaDetailContents(indexPath: IndexPath, completion: @escaping ((title: String, description: String, videoKey: String, mediaType: String, mediaID: String)) -> ()) {
        let mediaID = String(movies[indexPath.row]._id)
        let title = movies[indexPath.row]._title
        let description = movies[indexPath.row]._overview
        var videoID: String = ""
        
        mediaService.fetchVideo(with: Endpoint.fetchYoutubeVideoId(mediaType: "movie", mediaID: mediaID)) { videos in
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
            completion((title, description, videoID, "movie", mediaID))
        }
    }
    
    func searchForMovie(with query: String, resultVC: SearchResultsViewController) {
        mediaService.fetchMedias(with: Endpoint.fetchSearchMovies(query: query)) { searchResult in
            DispatchQueue.main.async {
                resultVC.viewModel.medias = searchResult.filter { $0.posterPath != nil }
                resultVC.viewModel.reloadSearchResultCollection()
            }
        }
    }
}

extension SearchViewModel: SearchViewModelProtocol {
    func fetchMovies(sortBy: String, voteCountGreaterThan: String?) {
        if let voteCountGreaterThan = voteCountGreaterThan {
            mediaService.fetchMedias(with: Endpoint.fetchDiscoverMoviesFilterByVoteCount(sortBy: sortBy, voteCountGreaterThan: voteCountGreaterThan)) { [weak self] discoveredMovies in
                self?.movies = discoveredMovies
                self?.view?.reloadCollection()
            }
        }else {
            mediaService.fetchMedias(with: Endpoint.fetchDiscoverMovies(sortBy: sortBy)) { [weak self]
                discoveredMovies in
                self?.movies = discoveredMovies
                self?.view?.reloadCollection()
            }
        }
    }
    
    func viewDidLoad() {
        view?.prepareNavBar()
        view?.prepareLabels()
        view?.prepareButton()
        view?.prepareCollectionViews()
        view?.prepareSearchController()
        self.fetchMovies(sortBy: "vote_count.desc", voteCountGreaterThan: nil)
        self.fetchPopularActors()
    }
}
