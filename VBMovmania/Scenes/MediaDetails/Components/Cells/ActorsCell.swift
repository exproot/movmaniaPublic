//
//  ActorsCell.swift
//  VBMovmania
//
//  Created by Suheda on 18.07.2024.
//

import UIKit

final class ActorsCell: UICollectionViewCell {
    static let reuseID = "ActorsCell"
    
    private let posterView: UIImageView = {
        let pv = UIImageView()
        pv.contentMode = .scaleAspectFill
        return pv
    }()
    
    private var actorName = UILabel()
    private var characterName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        prepareLabels()
        prepareImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setActorCellContent(path: String, name: String, character: String) {
        actorName.text = name
        characterName.text = character
        guard let url = URL(string: "\(Constants.imageBaseURL)\(path)") else { return }
        if path == "" {
            posterView.image = UIImage(systemName: "person.slash.fill")
            posterView.tintColor = .label
        }else {
            posterView.sd_setImage(with: url)
        }
    }
    
    private func prepareImageView() {
        posterView.clipsToBounds = true
        posterView.layer.cornerRadius = 100 / 2
    }
    
    private func prepareLabels() {
        actorName.font = .systemFont(ofSize: 14, weight: .regular)
        actorName.textColor = .label
        actorName.textAlignment = .center
        characterName.font = .systemFont(ofSize: 12, weight: .regular)
        characterName.textColor = .secondaryLabel
        characterName.textAlignment = .center
    }
    
    private func setupUI() {
        contentView.addSubview(posterView)
        contentView.addSubview(actorName)
        contentView.addSubview(characterName)
        
        posterView.translatesAutoresizingMaskIntoConstraints = false
        actorName.translatesAutoresizingMaskIntoConstraints = false
        characterName.translatesAutoresizingMaskIntoConstraints = false
        
//        posterView.backgroundColor = .orange
//        actorName.backgroundColor = .blue
//        characterName.backgroundColor = .orange
//        contentView.backgroundColor = .lightGray
        
        NSLayoutConstraint.activate([
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterView.centerXAnchor.constraint(equalTo: centerXAnchor),
            posterView.widthAnchor.constraint(equalToConstant: 100),
            posterView.heightAnchor.constraint(equalToConstant: 100),
            
            actorName.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 5),
            actorName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            actorName.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            actorName.heightAnchor.constraint(equalToConstant: 15),
            
            characterName.topAnchor.constraint(equalTo: actorName.bottomAnchor, constant: 5),
            characterName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            characterName.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            characterName.heightAnchor.constraint(equalToConstant: 12),
        ])
    }
}
