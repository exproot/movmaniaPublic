//
//  DetailsPosterCell.swift
//  VBMovmania
//
//  Created by Suheda on 18.07.2024.
//

import UIKit

final class DetailsPosterCell: UICollectionViewCell {
    static let reuseID = "DetailsPosterCell"
    
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
    
    public func setDetailsPosterCell(path: String) {
        guard let url = URL(string: "\(Constants.imageBaseURL)\(path)") else { return }
        
        posterView.sd_setImage(with: url)
    }
    
    private func setupUI() {
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.label.cgColor
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
