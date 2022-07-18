//
//  ActiveChatCell.swift
//  iChat
//
//  Created by Илья Синицын on 06.07.2022.
//

import UIKit

class ActiveChatCell: UICollectionViewCell, ProtocolConfigurationCell {
    
    static var reuseId: String = "ActiveChatCell"
    
    let imageView = UIImageView()
    let gradientView = GradientView(from: .trailing, to: .bottomLeading, startColor: .myLightPurple, endColor: .myLightBlue)
    
    let nameLabel = UILabel(text: "User name", font: .laoSangamMN20)
    let messageLabel = UILabel(text: "Massage", font: .laoSangamMN18)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ConfigurationCell
extension ActiveChatCell {
    
    func configurationCell<U>(with value: U) where U : Hashable {
        guard let user: MChat = value as? MChat else { return }
        
//        if user.userImage == "" {
//            imageView.image = UIImage(named: "avatar")
//        } else {
//            imageView.image = UIImage(named: user.userImage)
//        }
//        
//        nameLabel.text = user.userName
//        messageLabel.text = user.message
    }
}

// MARK: - SetupUI
extension ActiveChatCell {
    
    private func setupUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
}

// MARK: - SetupConstraints
extension ActiveChatCell {
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [imageView, gradientView, nameLabel, messageLabel].forEach({self.addSubview($0)})
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 78),
            imageView.widthAnchor.constraint(equalToConstant: 78)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            messageLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 8)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct ActiveChatCellProvider: PreviewProvider {
    static var previews: some  View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = MainTabBarController()
         
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
