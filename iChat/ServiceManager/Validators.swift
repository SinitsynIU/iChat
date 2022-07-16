//
//  Validators.swift
//  iChat
//
//  Created by Илья Синицын on 08.07.2022.
//

import Foundation

class Validators {
    
    static func isFiffedRegistration(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard let password = password, let email = email, let confirmPassword = confirmPassword, password != "", confirmPassword != "", email != "" else { return false }
        return true
    }
    
    static func isFiffedSignIn(email: String?, password: String?) -> Bool {
        guard let password = password, let email = email, password != "", email != "" else { return false }
        return true
    }
    
    static func isSimpleEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
    
    static func isSimplePassword(password: String) -> Bool {
        let passwordRegEx = "^.{8,}$" //"^(?!.[^a-zA-Z0-9@#${'$'}^+=])"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: password)
    }
    
    static func isFiffedFirestore(userName: String?, sex: String?) -> Bool {
        guard let userName = userName, let sex = sex, sex != "", userName != "" else { return false }
        return true
    }
}
