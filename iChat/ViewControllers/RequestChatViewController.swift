//
//  RequestChatViewController.swift
//  iChat
//
//  Created by Илья Синицын on 07.07.2022.
//

import UIKit

class RequestChatViewController: UIViewController {
    
    let containerView = UIView()
    let imageView = UIImageView(image: UIImage(named: "avatar"), contentMode: .scaleAspectFill)
    
    let nameLabel = UILabel(text: "", font: .systemFont(ofSize: 20, weight: .light))
    let aboutMeLabel = UILabel(text: "", font: .systemFont(ofSize: 16, weight: .light))
    
    let acceptButton = UIButton(title: "ACCEPT", titleColor: .white, font: .laoSangamMN20, backgroundColor: .black, isShadow: false, cornerRadius: 10)
    let denyButton = UIButton(title: "DENY", titleColor: .myLightRed, font: .laoSangamMN20, backgroundColor: .myWhite, isShadow: false, cornerRadius: 10)
    
    weak var delegate: ProtocolWaitingChatsNavigation?
    
    private var chat: MChat
    
    init(chat: MChat) {
        self.chat = chat
        nameLabel.text = chat.friendUserName
        imageView.sd_setImage(with: URL(string: chat.friendUserImage), completed: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.acceptButton.applyGradients(cornerRadius: 10)
    }
}

// MARK: - SetupUI
extension RequestChatViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
        aboutMeLabel.numberOfLines = 0
        containerView.backgroundColor = .myWhite
        containerView.layer.cornerRadius = 30
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = UIColor.myLightRed.cgColor
    }
}

// MARK: - SetupActions
extension RequestChatViewController {
    
    private func setupActions() {
        denyButton.addTarget(self, action: #selector(denyButtonAction), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonAction), for: .touchUpInside)
    }
        
    @objc private func denyButtonAction() {
        self.dismiss(animated: true) {
            self.delegate?.removeWaitingChat(chat: self.chat)
        }
    }
    
    @objc private func acceptButtonAction() {
        self.dismiss(animated: true) {
            self.delegate?.chatToActive(chat: self.chat)
        }
    }
}

// MARK: - SetupConstraints
extension RequestChatViewController {
    
    private func setupConstraints() {
        let buttonsStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 7)
        buttonsStackView.distribution = .fillEqually
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [imageView, containerView].forEach({view.addSubview($0)})
        [nameLabel, aboutMeLabel, buttonsStackView].forEach({containerView.addSubview($0)})
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 206)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 24),
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}
