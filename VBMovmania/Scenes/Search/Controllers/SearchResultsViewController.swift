//
//  SearchResultsViewController.swift
//  VBMovmania
//
//  Created by Suheda on 13.07.2024.
//

import UIKit

protocol SearchResultsViewControllerProtocol: AnyObject {
    func prepareCollectionView()
    func reloadCollection()
}

protocol SearchResultsViewProtocol : AnyObject{
    func searchResultsViewControllerDidTapItem(title: String, description: String, youtubeKey: String, mediaType: String, mediaID: String)
}

final class SearchResultsViewController: UIViewController {
    public lazy var viewModel = SearchResultsViewModel()
    public weak var delegate: SearchResultsViewProtocol?
    
    public let searchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 8, height: 180)
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchCollectionView.frame = view.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(searchCollectionView)
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseID, for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        
        cell.setCollectionCell(path: viewModel.medias[indexPath.row]._posterPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.getMediaContent(indexPath: indexPath) { [weak self] (title: String, description: String, videoKey: String, mediaType: String, mediaID: String) in
            self?.delegate?.searchResultsViewControllerDidTapItem(title: title, description: description, youtubeKey: videoKey, mediaType: mediaType, mediaID: mediaID)
        }
    }
}

extension SearchResultsViewController: SearchResultsViewControllerProtocol {
    func reloadCollection() {
        DispatchQueue.main.async { [weak self] in
            self?.searchCollectionView.reloadData()
        }
    }
    
    func prepareCollectionView() {
        searchCollectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseID)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
    }
}
