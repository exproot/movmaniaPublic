//
//  ForgotPasswordViewController.swift
//  VBMovmania
//
//  Created by Suheda on 21.07.2024.
//

import UIKit

protocol ForgotPasswordViewControllerProtocol: AnyObject {
    func prepareButton()
    func prepareNavBar()
    func showInvalidEmailAlert()
    func showErrorSendingPasswordResetAlert(with error: Error)
    func showPasswordResetSentAlert()
}

final class ForgotPasswordViewController: UIViewController {
    private lazy var viewModel = ForgotPasswordViewModel()
    private let headerView = AuthHeaderView(title: "Forgot My Password", subTitle: "Reset your password via your email.")
    private let emailField = CustomTextField(fieldType: .email)
    private let resetPassButton = CustomButton(title: "Send", hasBackground: true, fontWeight: .bold)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    //MARK: - Selectors
    @objc private func handleTapResetButton() {
        let email = emailField.text ?? ""
        
        viewModel.handleResetPassword(with: email)
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(resetPassButton)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        resetPassButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 190),
            
            emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 18),
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            resetPassButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 12),
            resetPassButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetPassButton.heightAnchor.constraint(equalToConstant: 50),
            resetPassButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
        ])
    }
}

extension ForgotPasswordViewController: ForgotPasswordViewControllerProtocol {
    func showPasswordResetSentAlert() {
        AlertManager.showPasswordResetSent(on: self)
    }
    
    func showErrorSendingPasswordResetAlert(with error: any Error) {
        AlertManager.showErrorSendingPassReset(on: self, with: error)
    }
    
    func showInvalidEmailAlert() {
        AlertManager.showInvalidEmailAlert(on: self)
    }
    
    func prepareNavBar() {
        navigationController?.navigationBar.isHidden = false
    }
    
    func prepareButton() {
        resetPassButton.addTarget(self, action: #selector(handleTapResetButton), for: .touchUpInside)
    }
}
