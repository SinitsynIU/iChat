//
//  ProtocolAuthNavigatingDelegate.swift
//  iChat
//
//  Created by Илья Синицын on 08.07.2022.
//

import Foundation

protocol ProtocolAuthNavigatingDelegate: AnyObject {
    func toLoginVC()
    func toSignUpVC()
}
