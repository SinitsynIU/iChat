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
        if let image = image {
            let image = MKImage(url: nil, image: nil, placeholderImage: image, size: image.size)
            return .photo(image)
        } else {
            return .text(content)
        }
    }
    
    var image: UIImage? = nil
    var downloadUrl: URL? = nil
    
    init(user: MUser, content: String) {
        self.content = content
        self.sender = MKSender(senderId: user.uid, displayName: user.userName)
        self.sentDate = Date()
        self.uid = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let sentDate = data["created"] as? Timestamp,
        let senderId = data["senderID"] as? String,
        let senderName = data["senderName"] as? String else { return nil }
        
        self.sentDate = sentDate.dateValue()
        self.uid = document.documentID
        self.sender = MKSender(senderId: senderId, displayName: senderName)
       
        if let content = data["content"] as? String {
            self.content = content
            self.downloadUrl = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            self.downloadUrl = url
            self.content = ""
        } else {
            return nil
        }
    }
    
    init(user: MUser, image: UIImage) {
        self.sender = MKSender(senderId: user.uid, displayName: user.userName)
        self.image = image
        self.content = ""
        self.sentDate = Date()
        self.uid = nil
    }
    
    var representation: [String : Any] {
        var representation: [String : Any] = [
            "created": sentDate,
            "senderID": sender.senderId,
            "senderName": sender.displayName
        ]
        
        if let url = downloadUrl {
            representation["url"] = url.absoluteString
        } else {
            representation["content"] = content
        }
        
        return representation
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

extension MMessage: Comparable {
    static func < (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
