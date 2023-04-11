//
//  SetupProfileViewController.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit
import FirebaseAuth
import SDWebImage

class SetupProfileViewController: UIViewController {
    
    let welcomLabel = UILabel(text: "Set up profile!", font: .myAvenir26)
    let fullNameLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    
    let fullNameTextField = OneLineTextField(font: .myAvenir20)
    let aboutMeTextField = OneLineTextField(font: .myAvenir20)
    
    let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    
    let goToChatsButton = UIButton(title: "Go to chats!", titleColor: .white, backgroundColor:  .myBlack, cornerRadius: 4)
    
    let imageView = AddPhotoView()
    
    private let currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        if let userName = currentUser.displayName {
            fullNameTextField.text = userName
        }
        if let imageURL = currentUser.photoURL {
            imageView.avatarImageView.sd_setImage(with: imageURL, completed: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupActions()
        subscribeToKeyboardShowHide()
        dismissKey()
    }
    
    deinit {
        unsubscribeToKeyboardShowHide()
    }
}

// MARK: - SetupActions
extension SetupProfileViewController {
    
    private func setupActions() {
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonActions), for: .touchUpInside)
        imageView.button.addTarget(self, action: #selector(addAvatarImageButtonActions), for: .touchUpInside)
    }
    
    @objc private func goToChatsButtonActions() {
        FirestoreServiceManager.shared.saveProfile(uid: currentUser.uid, email: currentUser.email!, userName: fullNameTextField.text, userImage: imageView.avatarImageView.image, description: aboutMeTextField.text, sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { (result) in
            switch result {
            case .success(let muser):
                let mainTabBar = MainTabBarController(currentUser: muser)
                mainTabBar.modalPresentationStyle = .fullScreen
                self.present(mainTabBar, animated: true, completion: nil)
            case .failure(let error):
                self.showAlert(titel: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func addAvatarImageButtonActions() {
        let imagePickerController  = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
        
    }
}

// MARK: - SetupUI
extension SetupProfileViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
    }
}

// MARK: - SetupConstraints
extension SetupProfileViewController {
    
    private func setupConstraints() {
    
        let fullNameStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField], axis: .vertical, spacing: 0)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField], axis: .vertical, spacing: 0)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl], axis: .vertical, spacing: 10)
        
        goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [fullNameStackView, aboutMeStackView, sexStackView, goToChatsButton], axis: .vertical, spacing: 30)
        
        welcomLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        [welcomLabel, imageView, stackView].forEach({view.addSubview($0)})
        
        NSLayoutConstraint.activate([
            welcomLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 170),
            welcomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: welcomLabel.bottomAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -40)
        ])
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension SetupProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageView.avatarImageView.image = image
    }
}

// MARK: - SwiftUI
import SwiftUI

struct SetupProfileViewControllerProvider: PreviewProvider {
    static var previews: some  View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = SetupProfileViewController(currentUser: Auth.auth().currentUser!)
         
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
