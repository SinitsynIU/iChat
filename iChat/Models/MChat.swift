//
//  MChat.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit
import FirebaseFirestore

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
    
    init(friendUserName: String, friendUserImage: String, friendId: String, messageContent: String) {
        self.friendUserName = friendUserName
        self.friendUserImage = friendUserImage
        self.friendId = friendId
        self.messageContent = messageContent
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let friendUserName = data["friendUserName"] as? String,
        let friendId = data["friendId"] as? String,
        let messageContent = data["messageContent"] as? String,
        let friendUserImage = data["friendUserImage"] as? String else { return nil }
    
        self.friendUserName = friendUserName
        self.friendId = friendId
        self.messageContent = messageContent
        self.friendUserImage = friendUserImage
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
    
//    func contains(filter: String?) -> Bool {
//        guard let filter = filter else { return true }
//        if filter.isEmpty { return true }
//        let lowercasedFilter = filter.lowercased()
//        return friendUserName.lowercased().contains(lowercasedFilter)
//    }
}
