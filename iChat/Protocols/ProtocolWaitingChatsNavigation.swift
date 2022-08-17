//
//  ProtocolWaitingChatsNavigation.swift
//  iChat
//
//  Created by Илья Синицын on 18.07.2022.
//

import Foundation

protocol ProtocolWaitingChatsNavigation: AnyObject {
    func removeWaitingChat(chat: MChat)
    func chatToActive(chat: MChat)
}
