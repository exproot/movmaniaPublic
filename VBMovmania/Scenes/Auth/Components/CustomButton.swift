//
//  CustomButton.swift
//  VBMovmania
//
//  Created by Suheda on 21.07.2024.
//

import UIKit

final class CustomButton: UIButton {
    enum FontWeight {
        case bold, med, small
    }
    
    init(title: String, hasBackground: Bool = false, fontWeight: FontWeight) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        layer.cornerRadius = 12
        layer.masksToBounds = true
        backgroundColor = hasBackground ? .systemBlue : .clear
        let titleColor: UIColor = hasBackground ? .white : .systemBlue
        setTitleColor(titleColor, for: .normal)
        
        switch fontWeight {
        case .bold:
            titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        case .med:
            titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        case .small:
            titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
