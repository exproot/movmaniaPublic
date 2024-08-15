//
//  LoginViewController.swift
//  VBMovmania
//
//  Created by Suheda on 21.07.2024.
//

import UIKit

protocol LoginViewControllerProtocol: AnyObject {
    func prepareButtons()
    func prepareNavBar()
    func checkAuthViaSceneDelegate()
    func showLogInAlert(with error: Error?)
    func showInvalidEmailAlert()
    func showInvalidPassAlert()
}

final class LoginViewController: UIViewController {
    private let viewModel = LoginViewModel()
    private let headerView = AuthHeaderView(title: "Log In", subTitle: "Log in to your account.")
    private let emailField = CustomTextField(fieldType: .email)
    private let passField = CustomTextField(fieldType: .password)
    private let signInButton = CustomButton(title: "Log in", hasBackground: true, fontWeight: .bold)
    private let newUserButton = CustomButton(title: "Dont have an account? Create one.", fontWeight: .med)
    private let forgotPassButton = CustomButton(title: "Forgot my password.", fontWeight: .small)

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
    @objc private func didTapSignIn() {
        let email = emailField.text ?? ""
        let password = passField.text ?? ""
        
        viewModel.handleLogIn(email: email, password: password)
    }
    
    @objc private func didTapNewUser() {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapForgotPass() {
        let vc = ForgotPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passField)
        view.addSubview(signInButton)
        view.addSubview(newUserButton)
        view.addSubview(forgotPassButton)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        newUserButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPassButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            signInButton.topAnchor.constraint(equalTo: passField.bottomAnchor, constant: 12),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 12),
            newUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newUserButton.heightAnchor.constraint(equalToConstant: 25),
            newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.72),
            
            forgotPassButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 10),
            forgotPassButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPassButton.heightAnchor.constraint(equalToConstant: 25),
            forgotPassButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35)
        ])
    }
}

extension LoginViewController: LoginViewControllerProtocol {
    func showInvalidEmailAlert() {
        AlertManager.showInvalidEmailAlert(on: self)
    }
    
    func showInvalidPassAlert() {
        AlertManager.showInvalidPasswordAlert(on: self)
    }
    
    func showLogInAlert(with error: Error?) {
        if let error = error {
            AlertManager.showLogInAlert(on: self, with: error)
        }else {
            AlertManager.showLogInAlert(on: self)
        }
    }
    
    func checkAuthViaSceneDelegate() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.checkAuthenticatedUser()
        } else {
            self.showLogInAlert(with: nil)
        }
    }
    
    func prepareNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func prepareButtons() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        forgotPassButton.addTarget(self, action: #selector(didTapForgotPass), for: .touchUpInside)
    }
}
