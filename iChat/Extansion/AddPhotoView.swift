//
//  AddPhotoView.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit

class AddPhotoView: UIView {
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "avatar")
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        let image = #imageLiteral(resourceName: "plus")
        button.setImage(image, for: .normal)
        button.tintColor = .myBlack
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        button.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        [avatarImageView, button].forEach({self.addSubview($0)})
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
