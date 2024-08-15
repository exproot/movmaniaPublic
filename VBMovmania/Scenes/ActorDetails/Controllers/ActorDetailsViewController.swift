//
//  ActorDetailsViewController.swift
//  VBMovmania
//
//  Created by Suheda on 25.07.2024.
//

import UIKit

protocol ActorDetailsViewControllerProtocol: AnyObject {
    func prepareLabels()
    func prepareCollectionView()
    func prepareImage()
    func reloadCollection()
    func presentLoadingView()
    func cancelLoadingView()
    func setImage(with url: URL?)
    func setNameLabel(with name: String?)
    func setBirthdayAndAgeLabel(with birthdayAndAge: String?)
    func setPlaceOfBirthLabel(with placeOfBirth: String?)
    func setBiographyLabel(with biography: String?)
}

protocol ActorDetailsViewControllerDelegate: AnyObject {
    func recommendedCellTapped(title: String, description: String, videoKey: String, mediaType: String, mediaID: String)
}

final class ActorDetailsViewController: UIViewController {
    private lazy var viewModel = ActorDetailsViewModel()
    weak var delegate: ActorDetailsViewControllerDelegate?
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let placeholderBirthday = UILabel()
    private let birthdayLabel = UILabel()
    private let placeholderPlaceOfBirth = UILabel()
    private let placeOfBirthLabel = UILabel()
    private let knownForLabel = UILabel()
    private var mediasCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 105, height: 150)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    private let bioTitleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let biographyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    init(actorId: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.actorID = actorId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(placeholderBirthday)
        view.addSubview(birthdayLabel)
        view.addSubview(placeholderPlaceOfBirth)
        view.addSubview(placeOfBirthLabel)
        view.addSubview(knownForLabel)
        view.addSubview(mediasCollectionView)
        view.addSubview(bioTitleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(biographyLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderBirthday.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderPlaceOfBirth.translatesAutoresizingMaskIntoConstraints = false
        placeOfBirthLabel.translatesAutoresizingMaskIntoConstraints = false
        knownForLabel.translatesAutoresizingMaskIntoConstraints = false
        mediasCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bioTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        biographyLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        nameLabel.backgroundColor = .blue
//        placeholderBirthday.backgroundColor = .orange
//        birthdayLabel.backgroundColor = .blue
//        placeholderPlaceOfBirth.backgroundColor = .orange
//        placeOfBirthLabel.backgroundColor = .blue
//        biographyLabel.backgroundColor = .orange
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor , constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            placeholderBirthday.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            placeholderBirthday.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            placeholderBirthday.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            birthdayLabel.topAnchor.constraint(equalTo: placeholderBirthday.bottomAnchor),
            birthdayLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            birthdayLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            placeholderPlaceOfBirth.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 8),
            placeholderPlaceOfBirth.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            placeholderPlaceOfBirth.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            placeOfBirthLabel.topAnchor.constraint(equalTo: placeholderPlaceOfBirth.bottomAnchor),
            placeOfBirthLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            placeOfBirthLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            knownForLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            knownForLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            knownForLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            mediasCollectionView.topAnchor.constraint(equalTo: knownForLabel.bottomAnchor, constant: 12),
            mediasCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            mediasCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mediasCollectionView.heightAnchor.constraint(equalToConstant: 155),
            
            bioTitleLabel.topAnchor.constraint(equalTo: mediasCollectionView.bottomAnchor, constant: 20),
            bioTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            bioTitleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            scrollView.topAnchor.constraint(equalTo: bioTitleLabel.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: biographyLabel.heightAnchor),
            
            biographyLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            biographyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            biographyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
        ])
    }
}

extension ActorDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.knownForMedias.count >= 10 {
            return 10
        } else {
            return viewModel.knownForMedias.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsPosterCell.reuseID, for: indexPath) as? DetailsPosterCell else { return UICollectionViewCell() }
        cell.setDetailsPosterCell(path: viewModel.knownForMedias[indexPath.item]._posterPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.knownForMedias.count > 0 {
            collectionView.deselectItem(at: indexPath, animated: true)
            viewModel.getContentForMediaDetails(indexPath: indexPath) { [weak self] content in
                DispatchQueue.main.async {
                    self?.delegate?.recommendedCellTapped(title: content.title, description: content.desc, videoKey: content.videoID, mediaType: content.mediaType, mediaID: content.mediaID)
                    self?.dismiss(animated: true)
                }
            }
        }else {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

extension ActorDetailsViewController: ActorDetailsViewControllerProtocol {
    func setBiographyLabel(with biography: String?) {
        if let biography = biography {
            self.biographyLabel.text = biography
        }else {
            self.biographyLabel.text = "No info"
        }
    }
    
    func setPlaceOfBirthLabel(with placeOfBirth: String?) {
        if let placeOfBirth = placeOfBirth {
            self.placeOfBirthLabel.text = placeOfBirth
        }else {
            self.placeOfBirthLabel.text = "No info"
        }
    }
    
    func setBirthdayAndAgeLabel(with birthdayAndAge: String?) {
        if let birthdayAndAge = birthdayAndAge {
            self.birthdayLabel.text = birthdayAndAge
        }else {
            self.birthdayLabel.text = "No info"
        }
    }
    
    func setNameLabel(with name: String?) {
        if let name = name {
            self.nameLabel.text = name
        }else {
            self.nameLabel.text = "No info"
        }
    }
    
    func setImage(with url: URL?) {
        if let url = url {
            self.imageView.sd_setImage(with: url)
        }else {
            self.imageView.tintColor = .label
            self.imageView.image = UIImage(systemName: "questionmark")
        }
    }
    
    func cancelLoadingView() {
        dismissLoadingView()
    }
    
    func presentLoadingView() {
        showLoadingView()
    }
    
    func reloadCollection() {
        DispatchQueue.main.async { [weak self] in
            self?.mediasCollectionView.reloadData()
        }
    }
    
    func prepareImage() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.2
        imageView.layer.borderColor = UIColor.label.cgColor
    }
    
    func prepareCollectionView() {
        mediasCollectionView.delegate = self
        mediasCollectionView.dataSource = self
        mediasCollectionView.register(DetailsPosterCell.self, forCellWithReuseIdentifier: DetailsPosterCell.reuseID)
    }
    
    func prepareLabels() {
        nameLabel.textColor = .label
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        placeholderBirthday.textColor = .label
        placeholderBirthday.font = .systemFont(ofSize: 16, weight: .bold)
        placeholderBirthday.text = "Birthday"
        birthdayLabel.textColor = .label
        birthdayLabel.font = .systemFont(ofSize: 16, weight: .regular)
        placeholderPlaceOfBirth.textColor = .label
        placeholderPlaceOfBirth.font = .systemFont(ofSize: 16, weight: .bold)
        placeholderPlaceOfBirth.text = "Place Of Birth"
        placeOfBirthLabel.textColor = .label
        placeOfBirthLabel.font = .systemFont(ofSize: 16, weight: .regular)
        placeOfBirthLabel.numberOfLines = 0
        placeOfBirthLabel.lineBreakMode = .byWordWrapping
        knownForLabel.font = .systemFont(ofSize: 28, weight: .bold)
        knownForLabel.text = "Known For"
        knownForLabel.textColor = .label
        bioTitleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        bioTitleLabel.text = "Biography"
        bioTitleLabel.textColor = .label
        biographyLabel.textColor = .secondaryLabel
        biographyLabel.font = .systemFont(ofSize: 16, weight: .regular)
        biographyLabel.numberOfLines = 0
        biographyLabel.lineBreakMode = .byWordWrapping
    }
}
