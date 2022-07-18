//
//  AuthViewController.swift
//  iChat
//
//  Created by Илья Синицын on 04.07.2022.
//

import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class AuthViewController: UIViewController {
    
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .myBlack)
    let loginButton = UIButton(title: "Login", titleColor: .myRed, backgroundColor: .white, isShadow: true)
    
    let loginVC = LoginViewController()
    let signUpVC = SignUpViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupActions()
        
        loginVC.delegate = self
        signUpVC.delegate = self
    }
}

// MARK: - SetupActions
extension AuthViewController {
    
    private func setupActions() {
        emailButton.addTarget(self, action: #selector(emailButtonActions), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonActions), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleLoginButtonActions), for: .touchUpInside)
    }
    
    @objc private func emailButtonActions() {
        present(SignUpViewController(), animated: true, completion: nil)
    }
    
    @objc private func loginButtonActions() {
        present(LoginViewController(), animated: true, completion: nil)
    }
    
    @objc private func googleLoginButtonActions() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

            AuthServiceManager.shered.googleLogin(user: user, error: error) { (result) in
                switch result {
                case .success(let user):
                    FirestoreServiceManager.shared.getUserData(user: user) { (result) in
                        switch result {
                        case .success(let muser):
                            UIApplication.getTopViewController()?.showAlert(titel: "Success", message: "You are registered.") {
                                let mainTabBar = MainTabBarController(currentUser: muser)
                                mainTabBar.modalPresentationStyle = .fullScreen
                                self.present(mainTabBar, animated: true, completion: nil)
                            }
                        case .failure(_):
                            UIApplication.getTopViewController()?.showAlert(titel: "Success", message: "You are registered.") {
                                let setupProfile = SetupProfileViewController(currentUser: user)
                                setupProfile.modalPresentationStyle = .fullScreen
                                self.present(setupProfile, animated: true, completion: nil)
                            }
                        }
                    }
                case .failure(let error):
                    self.showAlert(titel: "Error", message: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - SetupProtocolAuthNavigatingDelegate
extension AuthViewController: ProtocolAuthNavigatingDelegate {
    
    func toLoginVC() {
        present(loginVC, animated: true, completion: nil)
    }
    
    func toSignUpVC() {
        present(signUpVC, animated: true, completion: nil)
    }
}

// MARK: - SetupUI
extension AuthViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
        googleButton.customizeImageViewForButton()
    }
}

// MARK: - SetupConstraints
extension AuthViewController {
    
    private func setupConstraints() {
        let googleView = ButtonFromView(label: googleLabel, button: googleButton)
        let emailView = ButtonFromView(label: emailLabel, button: emailButton)
        let loginView = ButtonFromView(label: alreadyOnboardLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [logoImageView, stackView].forEach({view.addSubview($0)})
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct AuthViewControllerProvider: PreviewProvider {
    static var previews: some  View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = AuthViewController()
         
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
