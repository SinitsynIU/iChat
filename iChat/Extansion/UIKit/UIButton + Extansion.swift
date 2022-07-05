//
//  UIButton + Extansion.swift
//  iChat
//
//  Created by Илья Синицын on 04.07.2022.
//

import UIKit

extension UIButton {
    
    convenience init(title: String,
                     titleColor: UIColor,
                     font: UIFont? = .myAvenir20,
                     backgroundColor: UIColor,
                     isShadow: Bool = false,
                     cornerRadius: CGFloat = 4) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
        self.layer.cornerRadius = cornerRadius
    }
    
    func customizeImageViewForButton() {
        let image = UIImageView(image: #imageLiteral(resourceName: "googleLogo"), contentMode: .scaleAspectFit)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
