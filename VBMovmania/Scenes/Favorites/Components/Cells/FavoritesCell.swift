//
//  FavoritesCell.swift
//  VBMovmania
//
//  Created by Suheda on 22.07.2024.
//

import UIKit

final class FavoritesCell: UITableViewCell {
    static let reuseID = "FavoritesCell"
    
    private let mediaPosterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    private let mediaTitleLabel: UILabel = {
        let cl = UILabel()
        cl.textColor = .label
        cl.font = .systemFont(ofSize: 22, weight: .bold)
        cl.numberOfLines = 2
        return cl
    }()
    private let ratingLabelPlaceholder: UILabel = {
        let cl = UILabel()
        cl.text = "TMDB RATING"
        cl.font = .systemFont(ofSize: 14, weight: .medium)
        cl.textColor = .label
        return cl
    }()
    private var star = CustomStar(starType: "star.fill")
    private let mediaRatingLabel: UILabel = {
        let cl = UILabel()
        cl.font = .systemFont(ofSize: 14, weight: .semibold)
        cl.textColor = .label
        return cl
    }()
    private let mediaDescriptionLabel: UILabel = {
        let cl = UILabel()
        cl.textColor = .secondaryLabel
        cl.font = .systemFont(ofSize: 14, weight: .regular)
        cl.numberOfLines = 0
        return cl
    }()
    private let voteCountLabel: UILabel = {
        let cl = UILabel()
        cl.textColor = .label
        cl.font = .systemFont(ofSize: 14, weight: .light)
        return cl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setCell(path: String, name: String, desc: String, rating: String, voteCount: String) {
        guard let url = URL(string: "\(Constants.imageBaseURL)\(path)") else { return }
        mediaPosterImageView.sd_setImage(with: url)
        mediaTitleLabel.text = name
        mediaDescriptionLabel.text = desc
        mediaRatingLabel.text = rating
        voteCountLabel.text = "\(voteCount) users voted"
    }
    
    private func setupUI() {
        contentView.addSubview(mediaPosterImageView)
        contentView.addSubview(mediaTitleLabel)
        contentView.addSubview(ratingLabelPlaceholder)
        contentView.addSubview(star)
        contentView.addSubview(mediaRatingLabel)
        contentView.addSubview(voteCountLabel)
        contentView.addSubview(mediaDescriptionLabel)
        
        mediaPosterImageView.translatesAutoresizingMaskIntoConstraints = false
        mediaTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabelPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        star.translatesAutoresizingMaskIntoConstraints = false
        mediaRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        voteCountLabel.translatesAutoresizingMaskIntoConstraints = false
        mediaDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        mediaTitleLabel.backgroundColor = .blue
//        ratingLabelPlaceholder.backgroundColor = .orange
//        star.backgroundColor = .blue
//        mediaRatingLabel.backgroundColor = .orange
//        mediaDescriptionLabel.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            mediaPosterImageView.topAnchor.constraint(equalTo: self.topAnchor , constant: 16),
            mediaPosterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mediaPosterImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            mediaPosterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            mediaTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            mediaTitleLabel.leadingAnchor.constraint(equalTo: mediaPosterImageView.trailingAnchor, constant: 16),
            mediaTitleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65),
            
            ratingLabelPlaceholder.topAnchor.constraint(equalTo: mediaTitleLabel.bottomAnchor, constant: 12),
            ratingLabelPlaceholder.leadingAnchor.constraint(equalTo: mediaPosterImageView.trailingAnchor, constant: 16),
            ratingLabelPlaceholder.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            
            star.centerYAnchor.constraint(equalTo: ratingLabelPlaceholder.centerYAnchor),
            star.leadingAnchor.constraint(equalTo: ratingLabelPlaceholder.trailingAnchor, constant: 3),
            star.heightAnchor.constraint(equalToConstant: 20),
            star.widthAnchor.constraint(equalToConstant: 20),
            
            mediaRatingLabel.topAnchor.constraint(equalTo: mediaTitleLabel.bottomAnchor, constant: 12),
            mediaRatingLabel.leadingAnchor.constraint(equalTo: star.trailingAnchor, constant: 5),
            mediaRatingLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35),
            
            voteCountLabel.topAnchor.constraint(equalTo: ratingLabelPlaceholder.bottomAnchor, constant: 8),
            voteCountLabel.leadingAnchor.constraint(equalTo: ratingLabelPlaceholder.leadingAnchor),
            voteCountLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35),
            
            mediaDescriptionLabel.topAnchor.constraint(equalTo: voteCountLabel.bottomAnchor, constant: 5),
            mediaDescriptionLabel.leadingAnchor.constraint(equalTo: mediaPosterImageView.trailingAnchor, constant: 16),
            mediaDescriptionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65),
            mediaDescriptionLabel.bottomAnchor.constraint(equalTo: mediaPosterImageView.bottomAnchor)
//            mediaDescriptionLabel.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
