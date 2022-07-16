//
//  UserError.swift
//  iChat
//
//  Created by Илья Синицын on 08.07.2022.
//

import Foundation

enum UserError {
    case notFilled
    case imageNotExist
    case cannotUnwrapToMUser
    case cannotGetUserInfo
}

extension UserError: LocalizedError {
    var errorDescription: String?  {
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill all fields", comment: "")
        case .imageNotExist:
            return NSLocalizedString("No photo selected", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("It is not possible to get information about the user from Firebase", comment: "")
        case .cannotUnwrapToMUser:
            return NSLocalizedString("Сannot be convent MUser from User", comment: "")
        }
    }
}
