//
//  SearchViewController.swift
//  VBMovmania
//
//  Created by Suheda on 13.07.2024.
//

import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    func prepareNavBar()
    func prepareScrollView()
    func prepareLabels()
    func prepareButton()
    func prepareCollectionViews()
    func prepareSearchController()
    func reloadCollection()
}

final class SearchViewController: UIViewController {
    private let viewModel = SearchViewModel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let searchController = UISearchController(searchResultsController: SearchResultsViewController())
    private let actorsLabel = UILabel()
    private var actorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 120)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    private let discoverLabel = UILabel()
    private let sortDiscoverButton = UIButton()
    private var discoverCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 8, height: 180)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    func navigateToDetails(title: String, description: String, videoKey: String, mediaType: String, mediaID: String) {
        DispatchQueue.main.async { [weak self] in
            let vc = MediaDetailsViewController()
            vc.configure(title: title, desc: description, videoID: videoKey, mediaType: mediaType, mediaID: mediaID)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(actorsLabel)
        contentView.addSubview(actorsCollectionView)
        contentView.addSubview(discoverLabel)
        contentView.addSubview(sortDiscoverButton)
        contentView.addSubview(discoverCollectionView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        actorsLabel.translatesAutoresizingMaskIntoConstraints = false
        actorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        discoverLabel.translatesAutoresizingMaskIntoConstraints = false
        sortDiscoverButton.translatesAutoresizingMaskIntoConstraints = false
        discoverCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
//        discoverCollectionView.backgroundColor = .orange
//        sortDiscoverButton.backgroundColor = .orange
//        discoverLabel.backgroundColor = .orange
//        sortDiscoverButton.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1623),
            
            actorsLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 12),
            actorsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            actorsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            
            actorsCollectionView.topAnchor.constraint(equalTo: actorsLabel.bottomAnchor, constant: 8),
            actorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            actorsCollectionView.heightAnchor.constraint(equalToConstant: 160),
            
            discoverLabel.topAnchor.constraint(equalTo: actorsCollectionView.bottomAnchor, constant: 12),
            discoverLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            discoverLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            
            sortDiscoverButton.topAnchor.constraint(equalTo: discoverLabel.topAnchor),
            sortDiscoverButton.leadingAnchor.constraint(equalTo: discoverLabel.trailingAnchor),
            sortDiscoverButton.widthAnchor.constraint(equalToConstant: 30),
            sortDiscoverButton.bottomAnchor.constraint(equalTo: discoverLabel.bottomAnchor),
            
            discoverCollectionView.topAnchor.constraint(equalTo: discoverLabel.bottomAnchor, constant: 16),
            discoverCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            discoverCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            discoverCollectionView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.actorsCollectionView {
            if viewModel.popularActors.count <= 10 && viewModel.popularActors.count > 0 {
                return viewModel.popularActors.count
            }else if viewModel.popularActors.count > 10 {
                return 10
            }else {
                return 1
            }
        }else {
            return viewModel.movies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.actorsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorsCell.reuseID, for: indexPath) as? ActorsCell else { return UICollectionViewCell() }
            if viewModel.popularActors.count > 0 {
                cell.setActorCellContent(path: viewModel.popularActors[indexPath.item]._profilePath, name: viewModel.popularActors[indexPath.item]._name, character: "")
            } else {
                cell.setActorCellContent(path: "", name: "No actors", character: "No actors")
            }
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCell.reuseID, for: indexPath) as? DiscoverCell else { return UICollectionViewCell()}
            cell.setDetailsPosterCell(path: viewModel.movies[indexPath.item]._posterPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.actorsCollectionView {
            if viewModel.popularActors.count > 0 {
                collectionView.deselectItem(at: indexPath, animated: true)
                let actorId = String(viewModel.popularActors[indexPath.item]._id)
                let actorVc = ActorDetailsViewController(actorId: actorId)
                actorVc.delegate = self
                navigationController?.present(actorVc, animated: true)
            }else {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }else {
            collectionView.deselectItem(at: indexPath, animated: true)
            viewModel.getMediaDetailContents(indexPath: indexPath) { [weak self] (title: String, description: String, videoKey: String, mediaType: String, mediaID: String) in
                self?.navigateToDetails(title: title, description: description, videoKey: videoKey, mediaType: mediaType, mediaID: mediaID)
            }
        }
        
    }
}

extension SearchViewController: ActorDetailsViewControllerDelegate {
    func recommendedCellTapped(title: String, description: String, videoKey: String, mediaType: String, mediaID: String) {
        navigateToDetails(title: title, description: description, videoKey: videoKey, mediaType: mediaType, mediaID: mediaID)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBox = searchController.searchBar
        guard let searchQuery = 
                searchBox.text, !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty,
                searchQuery.trimmingCharacters(in: .whitespaces).count > 2,
                let resultController = searchController.searchResultsController as? SearchResultsViewController
        else { return }
        resultController.delegate = self
        viewModel.searchForMovie(with: searchQuery, resultVC: resultController)
    }
}

extension SearchViewController: SearchResultsViewProtocol {
    func searchResultsViewControllerDidTapItem(title: String, description: String, youtubeKey: String, mediaType: String, mediaID: String) {
        self.navigateToDetails(title: title, description: description, videoKey: youtubeKey, mediaType: mediaType, mediaID: mediaID)
    }
}

extension SearchViewController: SearchViewControllerProtocol {
    func prepareScrollView() {
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    func prepareButton() {
        sortDiscoverButton.tintColor = .label
        sortDiscoverButton.setImage(UIImage(systemName: "arrow.up.and.down.text.horizontal"), for: .normal)
        let menuWithItems = UIMenu(title: "Sort movies", options: .displayInline, children: [
            UIAction(title: "Popularity (desc)", handler: { [weak self] (_) in
                self?.viewModel.fetchMovies(sortBy: "popularity.desc", voteCountGreaterThan: nil)
                DispatchQueue.main.async {
                    self?.discoverLabel.text = "Popularity"
                }
            }),
            UIAction(title: "Top Rated (desc)", handler: { [weak self] (_) in
                self?.viewModel.fetchMovies(sortBy: "vote_average.desc", voteCountGreaterThan: "1000")
                DispatchQueue.main.async {
                    self?.discoverLabel.text = "Top Rated"
                }
            }),
            UIAction(title: "Most voted (desc)", handler: { [weak self] (_) in
                self?.viewModel.fetchMovies(sortBy: "vote_count.desc", voteCountGreaterThan: nil)
                DispatchQueue.main.async {
                    self?.discoverLabel.text = "Most Voted"
                }
            }),
        ])
        sortDiscoverButton.menu = menuWithItems
        sortDiscoverButton.showsMenuAsPrimaryAction = true
    }
    
    func reloadCollection() {
        DispatchQueue.main.async { [weak self] in
            self?.actorsCollectionView.reloadData()
            self?.discoverCollectionView.reloadData()
        }
    }
    
    func prepareLabels() {
        actorsLabel.font = .systemFont(ofSize: 28, weight: .bold)
        actorsLabel.text = "Popular Actors"
        actorsLabel.textColor = .label
        discoverLabel.font = .systemFont(ofSize: 28, weight: .bold)
        discoverLabel.text = "Most Voted"
        discoverLabel.textColor = .label
    }
    
    func prepareCollectionViews() {
        actorsCollectionView.register(ActorsCell.self, forCellWithReuseIdentifier: ActorsCell.reuseID)
        actorsCollectionView.delegate = self
        actorsCollectionView.dataSource = self
        discoverCollectionView.register(DiscoverCell.self, forCellWithReuseIdentifier:DiscoverCell.reuseID)
        discoverCollectionView.delegate = self
        discoverCollectionView.dataSource = self
    }
    
    func prepareSearchController() {
        searchController.searchBar.placeholder = "Search for a media"
        searchController.searchBar.searchBarStyle = .minimal
    }
    
    func prepareNavBar() {
        title = "Discover"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
    }
}
