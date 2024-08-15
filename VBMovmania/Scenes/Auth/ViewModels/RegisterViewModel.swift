//
//  RegisterViewModel.swift
//  VBMovmania
//
//  Created by Suheda on 25.07.2024.
//

import Foundation

protocol RegisterViewModelProtocol {
    var view: RegisterViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func handleSignUp(with email: String, and password: String)
}

final class RegisterViewModel {
    weak var view: RegisterViewControllerProtocol?
}

extension RegisterViewModel: RegisterViewModelProtocol {
    func handleSignUp(with email: String, and password: String) {
        if !AuthValidator.isValidEmail(for: email) {
            view?.showInvalidEmailAlert()
            return
        }
        
        if !AuthValidator.isValidPassword(for: password) {
            view?.showInvalidPassAlert()
            return
        }
        
        AuthService.shared.createUser(with: email, and: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let returnedUserData):
                let user = DBUser(auth: returnedUserData)
                UserService.shared.saveNewUser(user: user)
                view?.checkAuthViaSceneDelegate()
            case .failure(let error):
                view?.showRegistrationAlert(with: error)
            }
        }
    }
    
    func viewDidLoad() {
        view?.prepareTextView()
        view?.prepareButtons()
    }
}
