//
//  HomeViewModel.swift
//  VBMovmania
//
//  Created by Suheda on 17.07.2024.
//

import Foundation

enum Sections: Int {
    case TrendingWeekly = 0
    case PopularMovies = 1
    case PopularSeries = 2
    case Upcoming = 3
}

protocol HomeViewModelProtocol {
    var view: HomeViewControllerProtocol? { get set }
    
    func viewDidLoad()
}

final class HomeViewModel {
    weak var view: HomeViewControllerProtocol?
    private let mediaService = MediaService()
    public let sectionTitles: [String] = ["Trending this week", "Popular Movies", "Popular TV Series", "Upcoming Movies"]
    public var arrTrendingWeekly: [MediaResult] = []
    public var arrPopularMovies: [MediaResult] = []
    public var arrPopularSeries: [MediaResult] = []
    public var arrUpcoming: [MediaResult] = []
    
    private func fetchTrendingWeekly() {
        mediaService.fetchMedias(with: Endpoint.fetchTrendingWeekly()) { [weak self] weekly in
            self?.arrTrendingWeekly = weekly
            self?.view?.reloadTable()
        }
    }
    
    private func fetchPopularMovies() {
        mediaService.fetchMedias(with: Endpoint.fetchPopulars(mediaType: "movie")) { [weak self] movies in
            self?.arrPopularMovies = movies
            self?.view?.reloadTable()
        }
    }
    
    private func fetchPopularSeries() {
        mediaService.fetchMedias(with: Endpoint.fetchPopulars(mediaType: "tv")) { [weak self] series in
            self?.arrPopularSeries = series
            self?.view?.reloadTable()
        }
    }
    
    private func fetchUpcoming() {
        view?.presentLoadingView()
        mediaService.fetchMedias(with: Endpoint.fetchUpcomingMovies()) { [weak self] upcoming in
            self?.view?.cancelLoadingView()
            self?.arrUpcoming = upcoming
            self?.view?.reloadTable()
        }
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func viewDidLoad() {
        view?.prepareNavBar()
        view?.prepareTableView()
        fetchTrendingWeekly()
        fetchPopularMovies()
        fetchPopularSeries()
        fetchUpcoming()
    }
}
