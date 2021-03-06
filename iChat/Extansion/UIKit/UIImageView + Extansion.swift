//
//  UIImageView + Extansion.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit

extension UIImageView {
    
    convenience init(image: UIImage?,
                     contentMode: UIView.ContentMode) {
        self.init()
        self.image = image
        self.contentMode = contentMode
    }
    
    func setupColor(color: UIColor) {
        let image = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = image
        self.tintColor = color
    }
}
