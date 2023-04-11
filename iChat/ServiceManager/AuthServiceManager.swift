//
//  AuthServiceManager.swift
//  iChat
//
//  Created by Илья Синицын on 07.07.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthServiceManager {
   
    static let shered = AuthServiceManager()
    
    private let auth = Auth.auth()
    
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping(Result<User, Error>) -> Void) {
        guard Validators.isFiffedRegistration(email: email, password: password, confirmPassword: confirmPassword) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        guard password!.lowercased() == confirmPassword!.lowercased() else {
            completion(.failure(AuthError.passwordNotMatched))
            return
        }
        guard Validators.isSimpleEmail(email: email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        guard Validators.isSimplePassword(password: password!) else {
            completion(.failure(AuthError.invalidPassword))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func login(email: String?, password: String?, completion: @escaping(Result<User, Error>) -> Void) {
        guard Validators.isFiffedSignIn(email: email, password: password) else {
            completion(.failure(AuthError.notFilled))
            return
        }

        auth.signIn(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func googleLogin(user: GIDGoogleUser!, error: Error!, completion: @escaping(Result<User, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let user = user, let idToken = user.idToken?.tokenString else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: user.accessToken.tokenString)
        Auth.auth().signIn(with: credential) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}
