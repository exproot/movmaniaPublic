//
//  ForgotPasswordViewModel.swift
//  VBMovmania
//
//  Created by Suheda on 25.07.2024.
//

import Foundation

protocol ForgotPasswordViewModelProtocol {
    var view: ForgotPasswordViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func viewWillAppear()
    func handleResetPassword(with email: String)
}

final class ForgotPasswordViewModel {
    weak var view: ForgotPasswordViewControllerProtocol?
}

extension ForgotPasswordViewModel: ForgotPasswordViewModelProtocol {
    func handleResetPassword(with email: String) {
        if !AuthValidator.isValidEmail(for: email) {
            view?.showInvalidEmailAlert()
            return
        }
        
        AuthService.shared.resetPassword(with: email) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.view?.showErrorSendingPasswordResetAlert(with: error)
                return
            }
            
            self.view?.showPasswordResetSentAlert()
        }
    }
    
    func viewWillAppear() {
        view?.prepareNavBar()
    }
    
    func viewDidLoad() {
        view?.prepareButton()
    }
}
