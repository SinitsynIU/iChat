//
//  AuthError.swift
//  iChat
//
//  Created by Илья Синицын on 08.07.2022.
//

import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case invalidPassword
    case passwordNotMatched
    case unknownError
    case serverError
}

extension AuthError: LocalizedError {
    var errorDescription: String?  {
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill all fields", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Email format is not available", comment: "")
        case .invalidPassword:
            return NSLocalizedString("Password format is not available", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("Passwords do not match", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error", comment: "")
        case .serverError:
            return NSLocalizedString("Server error", comment: "")
        }
    }
}
