//
//  AuthHeaderView.swift
//  VBMovmania
//
//  Created by Suheda on 21.07.2024.
//

import UIKit

class AuthHeaderView: UIView {
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    init(title: String, subTitle: String) {
        super.init(frame: .zero)
        setupUI()
        prepareImage()
        prepareLabels()
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareImage() {
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "movmania")
    }
    
    private func prepareLabels() {
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.text = "Error"
        subTitleLabel.textColor = .secondaryLabel
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = .systemFont(ofSize: 18, weight: .regular)
        subTitleLabel.text = "Error"
    }
    
    private func setupUI() {
        self.addSubview(logoImageView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}
