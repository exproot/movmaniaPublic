//
//  LoginViewModel.swift
//  VBMovmania
//
//  Created by Suheda on 24.07.2024.
//

import Foundation

protocol LoginViewModelProtocol {
    var view: LoginViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func viewWillAppear()
    func handleLogIn(email: String, password: String)
}

final class LoginViewModel {
    weak var view: LoginViewControllerProtocol?
}

extension LoginViewModel: LoginViewModelProtocol {
    func handleLogIn(email: String, password: String) {
        if !AuthValidator.isValidEmail(for: email) {
            view?.showInvalidEmailAlert()
            return
        }
        
        if !AuthValidator.isValidPassword(for: password) {
            view?.showInvalidPassAlert()
            return
        }
        
        AuthService.shared.signIn(with: email, and: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.view?.checkAuthViaSceneDelegate()
            case .failure(let error):
                self.view?.showLogInAlert(with: error)
            }
        }
    }
    
    func viewWillAppear() {
        view?.prepareNavBar()
    }
    
    func viewDidLoad() {
        view?.prepareButtons()
    }
}
