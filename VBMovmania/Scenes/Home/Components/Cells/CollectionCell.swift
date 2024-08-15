//
//  CollectionCell.swift
//  VBMovmania
//
//  Created by Suheda on 13.07.2024.
//

import UIKit
import SDWebImage

final class CollectionCell: UICollectionViewCell {
    static let reuseID = "CollectionCell"
    
    private let posterView: UIImageView = {
        let pv = UIImageView()
        pv.contentMode = .scaleAspectFill
        return pv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setCollectionCell(path: String) {
        guard let url = URL(string: "\(Constants.imageBaseURL)\(path)") else { return }
        
        posterView.sd_setImage(with: url)
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        contentView.addSubview(posterView)
        posterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
