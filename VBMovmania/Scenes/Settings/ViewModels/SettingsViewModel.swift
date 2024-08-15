//
//  SettingsViewModel.swift
//  VBMovmania
//
//  Created by Suheda on 28.07.2024.
//

import Foundation
import FirebaseAuth
import SDWebImage

protocol SettingsViewModelProtocol {
    var view: SettingsViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func handleLogout()
    func handleClearingCache()
}

final class SettingsViewModel {
    weak var view: SettingsViewControllerProtocol?
    var user: User?
}

extension SettingsViewModel: SettingsViewModelProtocol {
    func handleClearingCache() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
    
    func handleLogout() {
        AuthService.shared.signOut { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            self?.view?.checkAuthenticationViaSceneDelegate()
        }
    }
    
    func viewDidLoad() {
        self.user = Auth.auth().currentUser
        view?.prepareLabels()
        view?.prepareButtons()
        view?.prepareImages()
        view?.prepareProfileView()
    }
}

