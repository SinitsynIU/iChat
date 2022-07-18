//
//  MChat.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit

struct MChat: Hashable, Decodable {
    var friendUserName: String
    var friendUserImage: String
    var messageContent: String
    var friendId: String
    
    var representation: [String : Any] {
        let representation = [
            "friendUserName": friendUserName,
            "friendUserImage": friendUserImage,
            "friendId": friendId,
            "messageContent": messageContent
        ]
        return representation
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lowercasedFilter = filter.lowercased()
        return friendUserName.lowercased().contains(lowercasedFilter)
    }
}
