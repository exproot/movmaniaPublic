//
//  FavoritesViewController.swift
//  VBMovmania
//
//  Created by Suheda on 22.07.2024.
//

import UIKit

protocol FavoritesViewControllerProtocol: AnyObject {
    func prepareNavBar()
    func prepareTableView()
    func reloadTable()
    func navigateToDetails(title: String, description: String, videoKey: String, mediaType: String, mediaID: String)
}

final class FavoritesViewController: UIViewController {
    private lazy var viewModel = FavoritesViewModel()
    private let favoritesTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(favoritesTableView)
        favoritesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoritesTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            favoritesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoritesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoritesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.medias.count > 0 {
            return viewModel.medias.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.medias.count > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.reuseID, for: indexPath) as? FavoritesCell else {
                return UITableViewCell()
            }
            let content = viewModel.getMediaContentForCell(indexPath: indexPath)
            cell.setCell(path: content.path, name: content.name, desc: content.desc, rating: content.rating, voteCount: content.voteCount)
            return cell
        } else {
            let cell = UITableViewCell()
            var config = cell.defaultContentConfiguration()
            config.text = "Add some favorites.."
            cell.contentConfiguration = config
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.medias.count > 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            viewModel.getYoutubeVideoKey(indexPath: indexPath)
        }else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if viewModel.medias.count > 0 {
            return .delete
        }else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.removeFromFavorites(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.medias.count > 0 {
            return 160
        }else {
            return 44
        }
    }
}

extension FavoritesViewController: FavoritesViewControllerProtocol {
    func navigateToDetails(title: String, description: String, videoKey: String, mediaType: String, mediaID: String) {
        DispatchQueue.main.async { [weak self] in
            let vc = MediaDetailsViewController()
            vc.configure(title: title, desc: description, videoID: videoKey, mediaType: mediaType, mediaID: mediaID)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    public func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.favoritesTableView.reloadData()
        }
    }
    
    func prepareTableView() {
        favoritesTableView.register(FavoritesCell.self, forCellReuseIdentifier: FavoritesCell.reuseID)
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
    }
    
    func prepareNavBar() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
    }
}
