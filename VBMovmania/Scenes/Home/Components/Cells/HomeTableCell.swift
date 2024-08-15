//
//  HomeTableCell.swift
//  VBMovmania
//
//  Created by Suheda on 12.07.2024.
//

import UIKit

protocol HomeTableCellProtocol: AnyObject {
    func prepareCollectionView()
    func reloadCollection()
}

protocol HomeTableCellDelegate: AnyObject {
    func tableCellCollectionViewDidTap(cell: HomeTableCell, title: String, description: String, videoID: String, mediaType: String, mediaID: String)
}

final class HomeTableCell: UITableViewCell {
    static let reuseID = "HomeTableCell"
    public lazy var viewModel = HomeTableCellViewModel()
    weak var delegate: HomeTableCellDelegate?
    
    private let mediaService = MediaService()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        viewModel.view = self
        viewModel.cellDidLoad()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        contentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension HomeTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseID, for: indexPath) as? CollectionCell else {
            return UICollectionViewCell()
        }
        cell.setCollectionCell(path: viewModel.media[indexPath.item]._posterPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.getYoutubeVideoKey(indexPath: indexPath) { [weak self] (title: String, description: String, videoID: String, mediaType: String, mediaID: String) in
            guard let self = self else { return }
            self.delegate?.tableCellCollectionViewDidTap(cell: self, title: title, description: description, videoID: videoID, mediaType: mediaType, mediaID: mediaID)
        }
    }
}

extension HomeTableCell: HomeTableCellProtocol {
    func reloadCollection() {
        collectionView.reloadData()
    }
    
    func prepareCollectionView() {
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
