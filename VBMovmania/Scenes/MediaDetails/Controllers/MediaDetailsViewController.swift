//
//  MediaDetailsViewController.swift
//  VBMovmania
//
//  Created by Suheda on 15.07.2024.
//

import UIKit
import youtube_ios_player_helper
import Lottie

protocol MediaDetailsViewControllerProtocol: AnyObject {
    func prepareCollectionView()
    func prepareScrollView()
    func prepareLabels()
    func prepareTrailerView()
    func prepareLoadingView()
    func prepareNoTrailersView()
    func prepareButtons()
    func setButtonUIToAddFavorites()
    func setButtonUIToRemoveFavorites()
    func reloadActors()
    func reloadRecommendations()
    func changeUIAddingFavorite()
    func startHeartAnimation()
}

final class MediaDetailsViewController: UIViewController {
    private lazy var viewModel = MediaDetailsViewModel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let topView = UIView()
    private let middleView = UIView()
    private var headerView = DetailsHeaderView(frame: CGRect(x: 0, y: 0, width: 393, height: 500))
    private let animationView = LottieAnimationView(name: "heart")
    private var addToFavoritesButton = UIButton()
    private let trailerLabel = UILabel()
    private let trailerWebView = YTPlayerView(frame: .zero)
    private let loadingView = UIView()
    private let noTrailerView = UIView()
    private let actorsLabel = UILabel()
    private var actorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 120)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    private let recommendedLabel = UILabel()
    private var recommendationsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 105, height: 150)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.view = self
        viewModel.viewDidLoad()
        headerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        viewModel.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    public func configure(title: String, desc: String, videoID: String, mediaType: String, mediaID: String) {
        self.viewModel.mediaId = mediaID
        self.viewModel.mediaType = mediaType
        headerView.setDetailsHeader(name: title, desc: desc, mediaType: mediaType, mediaId: mediaID)
        if videoID != "" {
            noTrailerView.isHidden = true
            trailerWebView.load(withVideoId: videoID, playerVars: ["playsinline" : 0])
        }else {
            noTrailerView.isHidden = false
            loadingView.isHidden = true
        }
        viewModel.getActors(mediaType: mediaType, mediaID: mediaID)
        viewModel.getRecommendations(mediaType: mediaType, mediaID: mediaID)
    }
    
    private func navigateToNewMediaDetails(title: String, description: String, videoKey: String, mediaType: String, mediaID: String) {
        DispatchQueue.main.async { [weak self] in
            let vc = MediaDetailsViewController()
            vc.configure(title: title, desc: description, videoID: videoKey, mediaType: mediaType, mediaID: mediaID)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - Selectors
    @objc private func handleTapAddToFavoritesButton() {
        viewModel.handleTapAddToFavoritesButton()
        animationView.isHidden = true
    }
    
    private func setupMiddleView() {
        contentView.addSubview(middleView)
        middleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            middleView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            middleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            middleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            middleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        middleView.addSubview(trailerLabel)
        middleView.addSubview(noTrailerView)
        middleView.addSubview(loadingView)
        middleView.addSubview(trailerWebView)
        middleView.addSubview(actorsLabel)
        middleView.addSubview(actorsCollectionView)
        middleView.addSubview(recommendedLabel)
        middleView.addSubview(recommendationsCollectionView)
        trailerLabel.translatesAutoresizingMaskIntoConstraints = false
        noTrailerView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        trailerWebView.translatesAutoresizingMaskIntoConstraints = false
        actorsLabel.translatesAutoresizingMaskIntoConstraints = false
        actorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recommendedLabel.translatesAutoresizingMaskIntoConstraints = false
        recommendationsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trailerLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8),
            trailerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            trailerLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            
            noTrailerView.topAnchor.constraint(equalTo: trailerLabel.bottomAnchor, constant: 12),
            noTrailerView.leadingAnchor.constraint(equalTo: trailerWebView.leadingAnchor),
            noTrailerView.trailingAnchor.constraint(equalTo: trailerWebView.trailingAnchor),
            noTrailerView.heightAnchor.constraint(equalToConstant: 140),
            
            loadingView.topAnchor.constraint(equalTo: trailerLabel.bottomAnchor, constant: 12),
            loadingView.leadingAnchor.constraint(equalTo: trailerWebView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailerWebView.trailingAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 140),
            
            trailerWebView.topAnchor.constraint(equalTo: trailerLabel.bottomAnchor, constant: 12),
            trailerWebView.leadingAnchor.constraint(equalTo: trailerLabel.leadingAnchor),
            trailerWebView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            trailerWebView.heightAnchor.constraint(equalToConstant: 140),
            
            actorsLabel.topAnchor.constraint(equalTo: trailerWebView.bottomAnchor, constant: 20),
            actorsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            actorsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            
            actorsCollectionView.topAnchor.constraint(equalTo: actorsLabel.bottomAnchor),
            actorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            actorsCollectionView.heightAnchor.constraint(equalToConstant: 160),
            
            recommendedLabel.topAnchor.constraint(equalTo: actorsCollectionView.bottomAnchor, constant: 20),
            recommendedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            recommendedLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),

            recommendationsCollectionView.topAnchor.constraint(equalTo: recommendedLabel.bottomAnchor, constant: 15),
            recommendationsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recommendationsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recommendationsCollectionView.heightAnchor.constraint(equalToConstant: 155)
        ])
        middleView.sendSubviewToBack(trailerWebView)
        middleView.bringSubviewToFront(loadingView)
    }
    
    private func setupTopView() {
        contentView.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 500),
        ])
        topView.addSubview(headerView)
        topView.addSubview(animationView)
        topView.addSubview(addToFavoritesButton)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        animationView.translatesAutoresizingMaskIntoConstraints = false
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        
//        addToFavoritesButton.backgroundColor = .orange
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 500),
            
            addToFavoritesButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -182),
            addToFavoritesButton.heightAnchor.constraint(equalToConstant: 30),
            addToFavoritesButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -12),
            addToFavoritesButton.widthAnchor.constraint(equalToConstant: 30),
            
            animationView.centerXAnchor.constraint(equalTo: addToFavoritesButton.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: addToFavoritesButton.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 100),
            animationView.heightAnchor.constraint(equalToConstant: 100),
        ])
        topView.bringSubviewToFront(animationView)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
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
            contentView.heightAnchor.constraint(equalToConstant: 1135)
        ])
        setupTopView()
        setupMiddleView()
    }
}

extension MediaDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.recommendationsCollectionView {
            if viewModel.recommended.count <= 10 {
                return viewModel.recommended.count
            } else {
                return 10
            }
        } else {
            if viewModel.actors.count <= 10 && viewModel.actors.count > 0 {
                return viewModel.actors.count
            }else if viewModel.actors.count > 10 {
                return 10
            }else {
                return 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.recommendationsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsPosterCell.reuseID, for: indexPath) as? DetailsPosterCell else { return UICollectionViewCell()}
            cell.setDetailsPosterCell(path: viewModel.recommended[indexPath.item]._posterPath)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorsCell.reuseID, for: indexPath) as? ActorsCell else { return UICollectionViewCell() }
            if viewModel.actors.count > 0 {
                cell.setActorCellContent(path: viewModel.actors[indexPath.item]._profilePath, name: viewModel.actors[indexPath.item]._name, character: viewModel.actors[indexPath.item]._character)
            } else {
                cell.setActorCellContent(path: "", name: "No actors", character: "No actors")
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.actorsCollectionView {
            if viewModel.actors.count > 0 {
                collectionView.deselectItem(at: indexPath, animated: true)
                let actorId = String(viewModel.actors[indexPath.item]._id)
                let actorVc = ActorDetailsViewController(actorId: actorId)
                actorVc.delegate = self
                navigationController?.present(actorVc, animated: true)
            }else {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }else {
            if viewModel.recommended.count > 0 {
                collectionView.deselectItem(at: indexPath, animated: true)
                viewModel.getContentForMediaDetails(indexPath: indexPath) { [weak self] content in
                    self?.navigateToNewMediaDetails(title: content.title, description: content.desc, videoKey: content.videoID, mediaType: content.mediaType, mediaID: content.mediaID)
                }
            }else {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }
}

extension MediaDetailsViewController: DetailsHeaderViewDelegate {
    func readMoreButtonTapped(description: String, title: String) {
        self.navigationController?.present(MediaDescriptionViewController(mediaDescription: description, mediaTitle: title), animated: true)
    }
}

extension MediaDetailsViewController: ActorDetailsViewControllerDelegate {
    func recommendedCellTapped(title: String, description: String, videoKey: String, mediaType: String, mediaID: String) {
        navigateToNewMediaDetails(title: title, description: description, videoKey: videoKey, mediaType: mediaType, mediaID: mediaID)
    }
}

extension MediaDetailsViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        loadingView.removeFromSuperview()
    }
}

extension MediaDetailsViewController: MediaDetailsViewControllerProtocol {
    func startHeartAnimation() {
        animationView.contentMode = .scaleAspectFit
        animationView.isUserInteractionEnabled = false
        animationView.loopMode = .playOnce
        animationView.play()
    }
    
    func changeUIAddingFavorite() {
        animationView.isHidden = false
    }
    
    func prepareScrollView() {
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    func reloadRecommendations() {
        DispatchQueue.main.async { [weak self] in
            self?.recommendationsCollectionView.reloadData()
        }
    }
    
    func reloadActors() {
        DispatchQueue.main.async { [weak self] in
            self?.actorsCollectionView.reloadData()
        }
    }
    
    func setButtonUIToAddFavorites() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.addToFavoritesButton.setImage(UIImage.init(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 100)), for: .normal)
            if self.animationView.isAnimationPlaying {
                self.animationView.isHidden = false
            } else {
                self.animationView.isHidden = true
            }
        }
    }
    
    func setButtonUIToRemoveFavorites() {
        DispatchQueue.main.async {
            self.addToFavoritesButton.setImage(UIImage.init(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 100)), for: .normal)
        }
    }
    
    func prepareButtons() {
        animationView.isHidden = true
        addToFavoritesButton.tintColor = .systemRed
        addToFavoritesButton.imageView?.contentMode = .scaleAspectFit
        addToFavoritesButton.addTarget(self, action: #selector(handleTapAddToFavoritesButton), for: .touchUpInside)
    }
    
    func prepareNoTrailersView() {
        noTrailerView.backgroundColor = .systemBackground
        let noTrailerLabel: UILabel = {
            let ntl = UILabel()
            ntl.text = "No Trailers"
            ntl.textColor = .label
            ntl.translatesAutoresizingMaskIntoConstraints = false
            return ntl
        }()
        noTrailerView.addSubview(noTrailerLabel)
        NSLayoutConstraint.activate([
            noTrailerLabel.centerYAnchor.constraint(equalTo: noTrailerView.centerYAnchor),
            noTrailerLabel.centerXAnchor.constraint(equalTo: noTrailerView.centerXAnchor)
        ])
        noTrailerView.layer.cornerRadius = 12
        noTrailerView.layer.borderWidth = 0.2
        noTrailerView.layer.borderColor = UIColor.label.cgColor
    }
    
    func prepareLoadingView() {
        loadingView.backgroundColor = .systemBackground
        loadingView.layer.cornerRadius = 12
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        loadingView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func prepareTrailerView() {
        trailerWebView.layer.cornerRadius = 12
        trailerWebView.layer.borderWidth = 0.2
        trailerWebView.clipsToBounds = true
        trailerWebView.layer.borderColor = UIColor.label.cgColor
        trailerWebView.delegate = self
    }
    
    func prepareLabels() {
        trailerLabel.font = .systemFont(ofSize: 28, weight: .bold)
        trailerLabel.text = "Trailer"
        trailerLabel.textColor = .label
        recommendedLabel.font = .systemFont(ofSize: 28, weight: .bold)
        recommendedLabel.text = "Recommended"
        recommendedLabel.textColor = .label
        actorsLabel.font = .systemFont(ofSize: 28, weight: .bold)
        actorsLabel.text = "Actors"
        actorsLabel.textColor = .label
    }
    
    func prepareCollectionView() {
        recommendationsCollectionView.register(DetailsPosterCell.self, forCellWithReuseIdentifier: DetailsPosterCell.reuseID)
        recommendationsCollectionView.delegate = self
        recommendationsCollectionView.dataSource = self
        actorsCollectionView.register(ActorsCell.self, forCellWithReuseIdentifier: ActorsCell.reuseID)
        actorsCollectionView.delegate = self
        actorsCollectionView.dataSource = self
        
    }
}
