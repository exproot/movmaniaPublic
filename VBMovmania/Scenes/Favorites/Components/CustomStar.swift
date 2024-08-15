//
//  CustomStar.swift
//  VBMovmania
//
//  Created by Suheda on 23.07.2024.
//

import UIKit

final class CustomStar: UIImageView {
    
    init(starType: String = "star") {
        super.init(frame: .zero)
        self.image = UIImage(systemName: starType)
        self.tintColor = .systemYellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
