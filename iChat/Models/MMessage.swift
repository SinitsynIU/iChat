//
//  MMessage.swift
//  iChat
//
//  Created by Илья Синицын on 17.07.2022.
//

import UIKit

struct MMessage: Hashable {
    let content: String
    let senderId: String
    let senderUserName: String
    var sentDate: Date
    let id:String?
    
    init(user: MUser, content: String) {
        self.content = content
        senderId = user.uid
        senderUserName = user.userName
        sentDate = Date()
        id = nil
    }
    
    var representation: [String : Any] {
        let representation: [String : Any] = [
            "creared": sentDate,
            "content": content,
            "senderId": senderId,
            "senderUserName": senderUserName
        ]
        return representation
    }
}
