//
//  AlertManager.swift
//  VBMovmania
//
//  Created by Suheda on 21.07.2024.
//

import UIKit

final class AlertManager {
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}

//MARK: - Field Alerts
extension AlertManager {
    public static func showInvalidEmailAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Invalid email", message: "Please enter a valid email adress.")
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Invalid password", message: "Please enter a valid password. Your password must meet the following criteria:\nMin 6 max 25 characters.\nAt least one uppercase letter and one digit.\nNo whitespaces.")
    }
}

//MARK: - Registration Alerts
extension AlertManager {
    public static func showRegistrationAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "An unknown registration error!", message: nil)
    }
    
    public static func showRegistrationAlert(on vc: UIViewController, with error: Error) {
        showBasicAlert(on: vc, with: "Registration Error", message: "\(error.localizedDescription)")
    }
}
//MARK: - Log In Alerts
extension AlertManager {
    public static func showLogInAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Couldn't log in, an unknown error!", message: nil)
    }
    
    public static func showLogInAlert(on vc: UIViewController, with error: Error) {
        showBasicAlert(on: vc, with: "Log In Error", message: "\(error.localizedDescription)")
    }
}
//MARK: - Log Out Alert
extension AlertManager {
    public static func showLogOutAlert(on vc: UIViewController, with error: Error) {
        showBasicAlert(on: vc, with: "Log Out Error", message: "\(error.localizedDescription)")
    }
}
//MARK: - Password Reset Alerts
extension AlertManager {
    public static func showPasswordResetSent(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Password reset request sent, check your email.", message: nil)
    }
    
    public static func showErrorSendingPassReset(on vc: UIViewController, with error: Error) {
        showBasicAlert(on: vc, with: "Password couldnt reset, unknown error!", message: "\(error.localizedDescription)")
    }
}
//MARK: - Fetching Alerts
extension AlertManager {
    public static func showUnknownFetchingUserError(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "An unknown error occurred while fetching user!", message: nil)
    }
    
    public static func showFetchingUserError(on vc: UIViewController, with error: Error) {
        showBasicAlert(on: vc, with: "Fetching Error", message: "\(error.localizedDescription)")
    }
}
