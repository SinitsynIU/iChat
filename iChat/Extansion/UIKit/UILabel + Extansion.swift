//
//  UILabel + Extansion.swift
//  iChat
//
//  Created by Илья Синицын on 04.07.2022.
//

import UIKit

extension UILabel {
    
    convenience init(text: String,
                     font: UIFont? = .myAvenir20) {
        self.init()
        self.text = text
        self.font = font
    }
}
