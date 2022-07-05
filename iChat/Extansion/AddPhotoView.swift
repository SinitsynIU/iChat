//
//  AddPhotoView.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit

class AddPhotoView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "avatar")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = #imageLiteral(resourceName: "plus")
        button.setImage(image, for: .normal)
        button.tintColor = .myBlack
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        [imageView, button].forEach({self.addSubview($0)})
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
