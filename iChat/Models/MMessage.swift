//
//  MMessage.swift
//  iChat
//
//  Created by Илья Синицын on 17.07.2022.
//

import UIKit
import FirebaseFirestore
import MessageKit

struct MMessage: Hashable, MessageType {
   
    var sender: SenderType
    let content: String
    var sentDate: Date
    let uid:String?
    
    var messageId: String {
        return uid ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        return .text(content)
    }
    
    init(user: MUser, content: String) {
        self.content = content
        sender = Sender(senderId: user.uid, displayName: user.userName)
        sentDate = Date()
        uid = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let sentDate = data["created"] as? Timestamp,
        let senderId = data["senderID"] as? String,
        let senderName = data["senderName"] as? String,
        let content = data["content"] as? String else { return nil }
        
        self.sentDate = sentDate.dateValue()
        self.uid = document.documentID
        sender = Sender(senderId: senderId, displayName: senderName)
        self.content = content
    }
    
    var representation: [String : Any] {
        let representation: [String : Any] = [
            "creared": sentDate,
            "content": content,
            "senderID": sender.senderId,
            "senderName": sender.displayName
        ]
        return representation
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}
