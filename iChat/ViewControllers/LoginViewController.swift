//
//  LoginViewController.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    let welcomLabel = UILabel(text: "Welcom back!", font: .myAvenir26)
    let loginLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let needAnAccountLabel = UILabel(text: "Need an account?")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .myBlack)
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.myRed, for: .normal)
        button.titleLabel?.font = .myAvenir20
        return button
    }()
    
    let emailTextField = OneLineTextField(font: .myAvenir20)
    let passwordTextField = OneLineTextField(font: .myAvenir20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
}

// MARK: - SetupUI
extension LoginViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
    }
}

// MARK: - SetupConstraints
extension LoginViewController {
    
    private func setupConstraints() {
        let loginView = ButtonFromView(label: loginLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, loginButton], axis: .vertical, spacing: 40)
        let needAnAccountStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButton], axis: .vertical, spacing: 0)
        
        welcomLabel.translatesAutoresizingMaskIntoConstraints = false
        loginView.translatesAutoresizingMaskIntoConstraints = false
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        needAnAccountStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [welcomLabel, loginView, orLabel, stackView, needAnAccountStackView].forEach({view.addSubview($0)})
        
        NSLayoutConstraint.activate([
            welcomLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            welcomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: welcomLabel.bottomAnchor, constant: 70),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            orLabel.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 30),
            orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            needAnAccountStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            needAnAccountStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct LoginViewControllerProvider: PreviewProvider {
    static var previews: some  View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = LoginViewController()
         
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
