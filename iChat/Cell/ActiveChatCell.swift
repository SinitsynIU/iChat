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
    
    let name = UILabel(text: "User name", font: .laoSangamMN20)
    let message = UILabel(text: "Massage", font: .laoSangamMN18)
    
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
    
    func configurationCell(with value: MChat) {
        imageView.image = UIImage(named: value.userImage)
        name.text = value.userName
        message.text = value.message
    }
}

// MARK: - SetupUI
extension ActiveChatCell {
    
    private func setupUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        imageView.backgroundColor = .blue
        gradientView.backgroundColor = .red
    }
}

// MARK: - SetupConstraints
extension ActiveChatCell {
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        
        [imageView, gradientView, name, message].forEach({self.addSubview($0)})
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 78),
            imageView.widthAnchor.constraint(equalToConstant: 78)
        ])
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            name.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            name.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            message.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            message.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            message.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
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
