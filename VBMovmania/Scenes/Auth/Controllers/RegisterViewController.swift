//
//  RegisterViewController.swift
//  VBMovmania
//
//  Created by Suheda on 21.07.2024.
//

import UIKit

protocol RegisterViewControllerProtocol: AnyObject {
    func prepareTextView()
    func prepareButtons()
    func showInvalidEmailAlert()
    func showInvalidPassAlert()
    func showRegistrationAlert(with error: Error?)
    func checkAuthViaSceneDelegate()
}

final class RegisterViewController: UIViewController {
    private lazy var viewModel = RegisterViewModel()
    private let headerView = AuthHeaderView(title: "Create an Account", subTitle: "Please enter your details to register.")
    private let emailField = CustomTextField(fieldType: .email)
    private let passField = CustomTextField(fieldType: .password)
    private let signUpButton = CustomButton(title: "Create", hasBackground: true, fontWeight: .bold)
    private let termsTextView = UITextView()
    private let signInButton = CustomButton(title: "Already have an account? Log in.", fontWeight: .med)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors
    @objc private func didTapSignUp() {
        let email = emailField.text ?? ""
        let password = passField.text ?? ""
        
        viewModel.handleSignUp(with: email, and: password)
    }
    
    @objc private func didTapSignIn() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passField)
        view.addSubview(signUpButton)
        view.addSubview(termsTextView)
        view.addSubview(signInButton)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passField.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        termsTextView.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 190),
            
            emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 18),
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            passField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 12),
            passField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passField.heightAnchor.constraint(equalToConstant: 50),
            passField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            signUpButton.topAnchor.constraint(equalTo: passField.bottomAnchor, constant: 12),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            termsTextView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 12),
            termsTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            termsTextView.heightAnchor.constraint(equalToConstant: 45),
            termsTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            signInButton.topAnchor.constraint(equalTo: termsTextView.bottomAnchor, constant: 12),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 35),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.70),
        ])
    }
}

extension RegisterViewController: RegisterViewControllerProtocol {
    func showRegistrationAlert(with error: Error?) {
        if let error = error {
            AlertManager.showRegistrationAlert(on: self, with: error)
        }else {
            AlertManager.showLogInAlert(on: self)
        }
    }
    
    func checkAuthViaSceneDelegate() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.checkAuthenticatedUser()
        }else {
            AlertManager.showRegistrationAlert(on: self)
        }
    }
    
    func showInvalidEmailAlert() {
        AlertManager.showInvalidEmailAlert(on: self)
    }
    
    func showInvalidPassAlert() {
        AlertManager.showInvalidPasswordAlert(on: self)
    }
    
    func prepareButtons() {
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    func prepareTextView() {
        termsTextView.text = "By creating an account you agree to our Terms & Conditions and you acknowledge that you have meet our Privacy Policy."
        termsTextView.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        termsTextView.backgroundColor = .clear
        termsTextView.textColor = .label
        termsTextView.isSelectable = false
        termsTextView.isEditable = false
        termsTextView.isScrollEnabled = false
        termsTextView.delaysContentTouches = false
    }
}
