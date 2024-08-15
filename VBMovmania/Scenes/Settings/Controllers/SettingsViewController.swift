//
//  SettingsViewController.swift
//  VBMovmania
//
//  Created by Suheda on 12.07.2024.
//

import UIKit
import FirebaseAuth
import SDWebImage

protocol SettingsViewControllerProtocol: AnyObject {
    func prepareLabels()
    func prepareButtons()
    func prepareImages()
    func prepareProfileView()
    func checkAuthenticationViaSceneDelegate()
}

final class SettingsViewController: UIViewController {
    private lazy var viewModel = SettingsViewModel()
    private let profileView = UIView()
    private let profileImage = UIImageView()
    private let accountLabel = UILabel()
    private let emailLabel = UILabel()
    private let clearCacheButton = UIButton()
    private let logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    //MARK: - Selectors
    @objc private func handleTapClearCacheButton() {
        viewModel.handleClearingCache()
    }
    
    @objc private func handleTapLogoutButton() {
        viewModel.handleLogout()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(profileView)
        profileView.addSubview(profileImage)
        profileView.addSubview(accountLabel)
        profileView.addSubview(emailLabel)
        view.addSubview(clearCacheButton)
        view.addSubview(logoutButton)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        clearCacheButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileView.heightAnchor.constraint(equalToConstant: 65),
            
            profileImage.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            profileImage.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 12),
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.heightAnchor.constraint(equalToConstant: 50),
            
            accountLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 6),
            accountLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            accountLabel.widthAnchor.constraint(equalTo: profileView.widthAnchor, multiplier: 0.45),
            accountLabel.heightAnchor.constraint(equalToConstant: 20),
            
            emailLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 2),
            emailLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            emailLabel.widthAnchor.constraint(equalTo: profileView.widthAnchor, multiplier: 0.75),
            
            clearCacheButton.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 12),
            clearCacheButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearCacheButton.heightAnchor.constraint(equalToConstant: 40),
            clearCacheButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            logoutButton.topAnchor.constraint(equalTo: clearCacheButton.bottomAnchor, constant: 12),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 40),
            logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
    }
}

extension SettingsViewController: SettingsViewControllerProtocol {
    func checkAuthenticationViaSceneDelegate() {
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.checkAuthenticatedUser()
        }
    }
    
    func prepareProfileView() {
        profileView.backgroundColor = .secondarySystemBackground
        profileView.layer.cornerRadius = 12
    }
    
    func prepareImages() {
        profileImage.tintColor = .lightGray
        profileImage.contentMode = .scaleAspectFit
        if let user = viewModel.user {
            DispatchQueue.main.async { [weak self] in
                if let firstLetterOfEmail = user.email?.first?.description {
                    self?.profileImage.image = UIImage(systemName: "\(firstLetterOfEmail).circle.fill")
                }else {
                    self?.profileImage.image = UIImage(systemName: "a.circle.fill")
                }
            }
        }
    }
    
    func prepareButtons() {
        clearCacheButton.backgroundColor = .secondarySystemBackground
        clearCacheButton.layer.cornerRadius = 12
        clearCacheButton.setTitle("Clear Image Cache", for: .normal)
        clearCacheButton.setTitleColor(.systemRed, for: .normal)
        clearCacheButton.titleLabel?.textAlignment = .left
        logoutButton.backgroundColor = .secondarySystemBackground
        logoutButton.layer.cornerRadius = 12
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(.systemBlue, for: .normal)
        logoutButton.titleLabel?.textAlignment = .left
        clearCacheButton.addTarget(self, action: #selector(handleTapClearCacheButton), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(handleTapLogoutButton), for: .touchUpInside)
    }
    
    func prepareLabels() {
        accountLabel.text = "Account"
        accountLabel.font = .systemFont(ofSize: 18, weight: .regular)
        accountLabel.textColor = .label
        emailLabel.text = viewModel.user?.email
        emailLabel.font = .systemFont(ofSize: 14, weight: .regular)
        emailLabel.textColor = .secondaryLabel
    }
}
