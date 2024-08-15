//
//  CustomTextField.swift
//  VBMovmania
//
//  Created by Suheda on 21.07.2024.
//

import UIKit

final class CustomTextField: UITextField {
    enum CustomTextFieldType {
        case username, email, password
    }
    
    private let fieldType: CustomTextFieldType
    
    init(fieldType: CustomTextFieldType) {
        self.fieldType = fieldType
        super.init(frame: .zero)
        
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        returnKeyType = .done
        autocorrectionType = .no
        autocapitalizationType = .none
        leftViewMode = .always
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        switch fieldType {
        case .username:
            placeholder = "Your Name"
        case .email:
            placeholder = "Email"
            keyboardType = .emailAddress
            textContentType = .oneTimeCode
        case .password:
            placeholder = "Password"
            isSecureTextEntry = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
