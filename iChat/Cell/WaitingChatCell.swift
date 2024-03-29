//
//  WaitingChatCell.swift
//  iChat
//
//  Created by Илья Синицын on 06.07.2022.
//

import UIKit

class WaitingChatCell: UICollectionViewCell, ProtocolConfigurationCell {
    
    static var reuseId: String = "WaitingChatCell"
    
    let imageView = UIImageView()
    
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
extension WaitingChatCell {
    
    func configurationCell<U>(with value: U) where U : Hashable {
        guard let chat: MChat = value as? MChat else { return }
        
        imageView.sd_setImage(with: URL(string: chat.friendUserImage), completed: nil)
    }
}

// MARK: - SetupUI
extension WaitingChatCell {
    
    private func setupUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
}

// MARK: - SetupConstraints
extension WaitingChatCell {
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        [imageView].forEach({self.addSubview($0)})
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct WaitingChatCellProvider: PreviewProvider {
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
