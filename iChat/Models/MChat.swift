//
//  MChat.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit

struct MChat: Hashable, Decodable {
    var userName: String
    var userImage: String
    var message: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.id == rhs.id
    }
}
