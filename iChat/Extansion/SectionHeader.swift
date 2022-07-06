//
//  SectionHeader.swift
//  iChat
//
//  Created by Илья Синицын on 06.07.2022.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    static var reuseId: String = "SectionHeader"
    
    let titelLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titelLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titelLabel)
        
        NSLayoutConstraint.activate([
            titelLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titelLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titelLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titelLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configurationSectionHeader(text: String, font: UIFont?, textColor: UIColor) {
        titelLabel.textColor = textColor
        titelLabel.font = font
        titelLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
