//
//  MediaDescriptionViewController.swift
//  VBMovmania
//
//  Created by Suheda on 28.07.2024.
//

import UIKit

final class MediaDescriptionViewController: UIViewController {
    private var titleLabel: UILabel = {
        let md = UILabel()
        md.textColor = .label
        md.font = .systemFont(ofSize: 18, weight: .bold)
        md.numberOfLines = 2
        md.textAlignment = .center
        return md
    }()
    private var mediaDescription: UILabel = {
        let md = UILabel()
        md.textColor = .label
        md.font = .systemFont(ofSize: 16, weight: .regular)
        md.numberOfLines = 0
        md.lineBreakMode = .byWordWrapping
        return md
    }()
    
    init(mediaDescription: String, mediaTitle: String) {
        self.mediaDescription.text = mediaDescription
        self.titleLabel.text = mediaTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(mediaDescription)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mediaDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            mediaDescription.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            mediaDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mediaDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])
    }
}
