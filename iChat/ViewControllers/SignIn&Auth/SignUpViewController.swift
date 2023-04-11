//
//  SignUpViewController.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let welcomLabel = UILabel(text: "Good to see you!", font: .myAvenir26)
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let confirmPasswordLabel = UILabel(text: "Confirm password")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
    let signUpButton = UIButton(title: "Sign Up", titleColor: .white, backgroundColor:  .myBlack, cornerRadius: 4)
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.myBlack, for: .normal)
        button.titleLabel?.font = .myAvenir20
        return button
    }()
    
    let emailTextField = OneLineTextField(font: .myAvenir20)
    let passwordTextField = OneLineTextField(font: .myAvenir20)
    let confirmPasswordTextField = OneLineTextField(font: .myAvenir20)
    
    weak var delegate: ProtocolAuthNavigatingDelegate?
    
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
extension SignUpViewController {
    
    private func setupActions() {
        signUpButton.addTarget(self, action: #selector(signUpButtonActions), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonActions), for: .touchUpInside)
    }
    
    @objc private func signUpButtonActions() {
        AuthServiceManager.shered.register(email: emailTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                let setupProfile = SetupProfileViewController(currentUser: user)
                setupProfile.modalPresentationStyle = .fullScreen
                self.present(setupProfile, animated: true, completion: nil)
            case .failure(let error):
                self.showAlert(titel: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func loginButtonActions() {
        dismiss(animated: true) {
            self.delegate?.toLoginVC()
        }
    }
}

// MARK: - SetupUI
extension SignUpViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
    }
}

// MARK: - SetupConstraints
extension SignUpViewController {
    
    private func setupConstraints() {
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextField], axis: .vertical, spacing: 0)
        
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, confirmPasswordStackView, signUpButton], axis: .vertical, spacing: 35)
        let alreadyOnboardStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton], axis: .vertical, spacing: 0)
        
        welcomLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        alreadyOnboardStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [welcomLabel, stackView, alreadyOnboardStackView].forEach({view.addSubview($0)})
        
        NSLayoutConstraint.activate([
            welcomLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            welcomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomLabel.bottomAnchor, constant: 110),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            alreadyOnboardStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            alreadyOnboardStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct SignUpViewControllerProvider: PreviewProvider {
    static var previews: some  View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = SignUpViewController()
         
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
