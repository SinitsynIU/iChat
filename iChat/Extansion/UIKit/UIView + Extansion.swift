//
//  UIView + Extansion.swift
//  iChat
//
//  Created by Илья Синицын on 07.07.2022.
//

import UIKit

extension UIView {
    
    func applyGradients(cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        
        let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: .myLightPurple, endColor: .myLightBlue)
        if let gradientsLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientsLayer.frame = self.bounds
            gradientsLayer.cornerRadius = cornerRadius
            self.layer.insertSublayer(gradientsLayer, at: 0)
        }
    }
}
