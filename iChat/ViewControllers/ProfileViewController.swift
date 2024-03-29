//
//  SetupProfileViewController.swift
//  iChat
//
//  Created by Илья Синицын on 07.07.2022.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    let containerView = UIView()
    let imageView = UIImageView(image: UIImage(named: "avatar"), contentMode: .scaleAspectFill)
    
    let nameLabel = UILabel(text: "", font: .systemFont(ofSize: 20, weight: .light))
    let aboutMeLabel = UILabel(text: "", font: .systemFont(ofSize: 16, weight: .light))
    
    let myTextField = InsertableTextField()
    
    private let user: MUser
    
    init(user: MUser) {
        self.user = user
        self.nameLabel.text = user.userName
        self.aboutMeLabel.text = user.description
        self.imageView.sd_setImage(with: URL(string: user.userImage), completed: nil)
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
        subscribeToKeyboardShowHideProfileViewController()
        dismissKey()
    }
    
    deinit {
        unsubscribeToKeyboardShowHide()
    }
    
    func subscribeToKeyboardShowHideProfileViewController() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowProfileViewController), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShowProfileViewController(notification: Notification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        self.view.frame.origin.y = -keyboardFrame.size.height / 1.2
    }
}

// MARK: - SetupUI
extension ProfileViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
        aboutMeLabel.numberOfLines = 0
        containerView.backgroundColor = .myWhite
        containerView.layer.cornerRadius = 30
    }
}

// MARK: - SetupActions
extension ProfileViewController {
    
    private func setupActions() {
        if let button = myTextField.rightView as? UIButton {
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
    }
        
    @objc private func sendMessage() {
        guard let message = myTextField.text, message != "" else { return }
            
        self.dismiss(animated: true) {
            FirestoreServiceManager.shared.createWaitingChat(message: message, receiver: self.user) { (result) in
                switch result {
                case .success():
                    UIApplication.getTopViewController()?.showAlert(titel: "Success", message: "Your message \(self.user.userName) was sent.")
                case .failure(let error):
                    UIApplication.getTopViewController()?.showAlert(titel: "Error", message: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - SetupConstraints
extension ProfileViewController {
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        myTextField.translatesAutoresizingMaskIntoConstraints = false
        
        [imageView, containerView].forEach({view.addSubview($0)})
        [nameLabel, aboutMeLabel, myTextField].forEach({containerView.addSubview($0)})
        
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
            myTextField.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 8),
            myTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            myTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            myTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
