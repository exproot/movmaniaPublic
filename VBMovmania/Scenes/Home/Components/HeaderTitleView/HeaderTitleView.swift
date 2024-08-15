//
//  HeaderTitleView.swift
//  VBMovmania
//
//  Created by Suheda on 12.07.2024.
//

import UIKit
import SDWebImage
import FirebaseAuth

protocol HeaderTitleViewDelegate: AnyObject {
    func headerTitleViewDidTap(view: UIView, title: String, description: String, videoID: String, mediaType: String, mediaID: String)
}

class HeaderTitleView: UIView {
    private let mediaService = MediaService()
    private var isFavorite: Bool = false
    private var dailies: [MediaResult] = []
    private var headerID: Int = Int.random(in: 0..<20)
    private var user: User?
    weak var delegate: HeaderTitleViewDelegate?
    
    public var headerImage: UIImageView = {
        let hi = UIImageView()
        hi.contentMode = .scaleAspectFill
        hi.clipsToBounds = true
        return hi
    }()
    private var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.font = .systemFont(ofSize: 28, weight: .bold)
        tl.textColor = .white
        tl.numberOfLines = 2
        return tl
    }()
    private var mediaTypeLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.font = .systemFont(ofSize: 18, weight: .bold)
        tl.textColor = .gray
        return tl
    }()
    private var descLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.font = .systemFont(ofSize: 14, weight: .medium)
        tl.textColor = .white
        tl.numberOfLines = 2
        return tl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.user = Auth.auth().currentUser
        setupUI()
        addGradient()
        setupTitles()
        getTrendingDaily()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapHeader))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        addGestureRecognizer(tapRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImage.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getTrendingDaily() {
        mediaService.fetchMedias(with: Endpoint.fetchTrendingDaily()) { [weak self] trendDaily in
            self?.dailies = trendDaily
            self?.setHeaderPoster()
        }
    }
    
    private func setHeaderPoster() {
        let id = self.headerID
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let url = URL(string: "\(Constants.imageBaseURL)\(self.dailies[id]._posterPath)") else { return }
            self.headerImage.sd_setImage(with: url)
            
            switch self.dailies[id]._mediaType {
            case "tv":
                self.titleLabel.text = self.dailies[id]._name
                self.mediaTypeLabel.text = "TV Series"
            case "movie":
                self.titleLabel.text = self.dailies[id]._title
                self.mediaTypeLabel.text = "Movie"
            default:
                self.mediaTypeLabel.text = "Movie"
            }
            
            self.descLabel.text = self.dailies[id]._overview
        }
    }
    
    //MARK: - Selectorrs
    @objc private func handleTapHeader() {
        let mediaID = String(dailies[self.headerID]._id)
        var title = ""
        let description = dailies[self.headerID]._overview
        let mediaType: String = self.dailies[self.headerID]._mediaType
        switch mediaType {
        case "movie":
            title = dailies[self.headerID]._title
        case "tv":
            title = dailies[self.headerID]._name
        default:
            title = ""
        }
        var videoID = ""
        
        mediaService.fetchVideo(with: Endpoint.fetchYoutubeVideoId(mediaType: mediaType, mediaID: mediaID)) { [weak self] videos in
            guard let self = self else { return }
            for i in videos {
                if i._type == "Trailer" {
                    videoID = i._key
                    break
                } else if videoID == "" && i._type == "Teaser" {
                    videoID = i._key
                } else if videoID == "" && i._type == "Clip" {
                    videoID = i._key
                } else {
                    videoID = i._key
                }
            }
            self.delegate?.headerTitleViewDidTap(view: self, title: title, description: description, videoID: videoID, mediaType: mediaType, mediaID: mediaID)
        }
        
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
    
    private func setupTitles() {
        addSubview(titleLabel)
        addSubview(mediaTypeLabel)
        addSubview(descLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mediaTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        titleLabel.backgroundColor = .orange
//        mediaTypeLabel.backgroundColor = .blue
//        descLabel.backgroundColor = .orange
//        addToWishlistButton.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: mediaTypeLabel.topAnchor, constant: -8),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.70),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            mediaTypeLabel.bottomAnchor.constraint(equalTo: descLabel.topAnchor, constant: -8),
            mediaTypeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.30),
            mediaTypeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            descLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            descLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.70),
            descLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
        ])
    }
    
    private func setupUI() {
        addSubview(headerImage)
    }
}
