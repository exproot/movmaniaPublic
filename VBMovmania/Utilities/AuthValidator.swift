//
//  AuthValidator.swift
//  VBMovmania
//
//  Created by Suheda on 21.07.2024.
//

import Foundation

final class AuthValidator {
    static func isValidEmail(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //Minimum 6 and Maximum 25 characters at least 1 uppercase, 1 digit and no whitespaces
    static func isValidPassword(for password: String) -> Bool {
        let passwordRegEx = "^(?=.*?[A-Z])(?=.*?[0-9])(?!.* ).{6,25}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
}
