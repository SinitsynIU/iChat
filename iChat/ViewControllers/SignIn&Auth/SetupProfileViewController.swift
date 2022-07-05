//
//  SetupProfileViewController.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
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
        
        let stackView = UIStackView(arrangedSubviews: [fullNameStackView, aboutMeStackView, sexStackView, goToChatsButton], axis: .vertical, spacing: 40)
        
        welcomLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [welcomLabel, imageView, stackView].forEach({view.addSubview($0)})
        
        NSLayoutConstraint.activate([
            welcomLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            welcomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: welcomLabel.bottomAnchor, constant: 40),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -40)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct SetupProfileViewControllerProvider: PreviewProvider {
    static var previews: some  View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = SetupProfileViewController()
         
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
