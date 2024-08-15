//
//  DetailsHeaderView.swift
//  VBMovmania
//
//  Created by Suheda on 23.07.2024.
//

import UIKit

protocol DetailsHeaderViewDelegate: AnyObject {
    func readMoreButtonTapped(description: String, title: String)
}

final class DetailsHeaderView: UIView {
    private let mediaService = MediaService()
    weak var delegate: DetailsHeaderViewDelegate?
    public var headerImage: UIImageView = {
        let hi = UIImageView()
        hi.contentMode = .scaleAspectFill
        hi.clipsToBounds = true
        return hi
    }()
    private var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .left
        tl.font = .systemFont(ofSize: 28, weight: .bold)
        tl.textColor = .white
        tl.numberOfLines = 2
        return tl
    }()
    private let ratingLabelPlaceholder: UILabel = {
        let cl = UILabel()
        cl.text = "TMDB RATING"
        cl.font = .systemFont(ofSize: 18, weight: .regular)
        cl.textColor = .white
        return cl
    }()
    private var star = CustomStar(starType: "star.fill")
    private let mediaRatingLabel: UILabel = {
        let cl = UILabel()
        cl.font = .systemFont(ofSize: 22, weight: .semibold)
        cl.textColor = .white
        return cl
    }()
    private let voteCountLabel: UILabel = {
        let cl = UILabel()
        cl.font = .systemFont(ofSize: 14, weight: .medium)
        cl.textColor = .gray
        return cl
    }()
    private let genreLabels: UILabel = {
        let cl = UILabel()
        cl.font = .systemFont(ofSize: 14, weight: .regular)
        cl.textColor = .white
        return cl
    }()
    private var descLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .left
        tl.font = .systemFont(ofSize: 16, weight: .medium)
        tl.textColor = .gray
        tl.numberOfLines = 0
        return tl
    }()
    private var readMoreButton: UIButton = {
        let bt = UIButton()
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addGradient()
        prepareLabels()
        prepareButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImage.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc private func handleTappedReadMore() {
        self.delegate?.readMoreButtonTapped(description: descLabel.text ?? "", title: titleLabel.text ?? "")
    }
    
    private func fetchMediaDetails(mediaId: String, mediaType: String) {
        mediaService.fetchMedia(with: Endpoint.fetchDetails(mediaType: mediaType, mediaID: mediaId)) { [weak self] media in
            self?.setPoster(path: media._posterPath)
            let average = String(round(10 * media._voteAverage) / 10)
            let votes = String(media._voteCount)
            let rating = "\(average)/10"
            guard let genres = media.genres else { return }
            var genreArray: [String] = []
            DispatchQueue.main.async { [weak self] in
                self?.mediaRatingLabel.text = rating
                self?.voteCountLabel.text = "(\(votes) users voted)"
                for i in 0..<genres.count {
                    genreArray.append(genres[i]._name)
                }
                self?.genreLabels.text = genreArray.joined(separator: ", ")
            }
        }
    }
    
    public func setDetailsHeader(name: String, desc: String, mediaType: String, mediaId: String) {
        fetchMediaDetails(mediaId: mediaId, mediaType: mediaType)
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = name
            self?.descLabel.text = desc
        }
    }
    
    private func setPoster(path: String) {
        guard let url = URL(string: "\(Constants.imageBaseURL)\(path)") else { return }
        self.headerImage.sd_setImage(with: url)
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func prepareButton() {
        readMoreButton.backgroundColor = .black
        readMoreButton.setTitle("READ MORE", for: .normal)
        readMoreButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        readMoreButton.setTitleColor(.white, for: .normal)
        readMoreButton.addTarget(self, action: #selector(handleTappedReadMore), for: .touchUpInside)
    }
    
    private func prepareLabels() {
        addSubview(titleLabel)
        addSubview(ratingLabelPlaceholder)
        addSubview(star)
        addSubview(mediaRatingLabel)
        addSubview(voteCountLabel)
        addSubview(genreLabels)
        addSubview(descLabel)
        addSubview(readMoreButton)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabelPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        star.translatesAutoresizingMaskIntoConstraints = false
        mediaRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        voteCountLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabels.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        readMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
//        titleLabel.backgroundColor = .blue
//        mediaRatingLabel.backgroundColor = .orange
//        voteCountLabel.backgroundColor = .blue
//        genreLabels.backgroundColor = .orange
//        descLabel.backgroundColor = .orange
//        readMoreButton.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: -150),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            
            ratingLabelPlaceholder.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            ratingLabelPlaceholder.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            ratingLabelPlaceholder.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.32),
            
            star.centerYAnchor.constraint(equalTo: ratingLabelPlaceholder.centerYAnchor),
            star.leadingAnchor.constraint(equalTo: ratingLabelPlaceholder.trailingAnchor, constant: 3),
            star.heightAnchor.constraint(equalToConstant: 20),
            star.widthAnchor.constraint(equalToConstant: 20),
            
            mediaRatingLabel.centerYAnchor.constraint(equalTo: star.centerYAnchor),
            mediaRatingLabel.leadingAnchor.constraint(equalTo: star.trailingAnchor, constant: 5),
            mediaRatingLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.18),
            
            voteCountLabel.centerYAnchor.constraint(equalTo: star.centerYAnchor),
            voteCountLabel.leadingAnchor.constraint(equalTo: mediaRatingLabel.trailingAnchor, constant: 5),
            voteCountLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35),
            
            genreLabels.topAnchor.constraint(equalTo: mediaRatingLabel.bottomAnchor, constant: 6),
            genreLabels.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            genreLabels.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.84),
            genreLabels.heightAnchor.constraint(equalToConstant: 25),
            
            descLabel.topAnchor.constraint(equalTo: genreLabels.bottomAnchor, constant: 6),
            descLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            descLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            descLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            
            readMoreButton.bottomAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: -4),
            readMoreButton.leadingAnchor.constraint(equalTo: descLabel.trailingAnchor, constant: -108),
            readMoreButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.28),
            readMoreButton.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
    
    private func setupUI() {
        addSubview(headerImage)
    }
}
