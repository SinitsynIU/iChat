//
//  MUser.swift
//  iChat
//
//  Created by Илья Синицын on 06.07.2022.
//

import UIKit
import FirebaseFirestore

struct MUser: Hashable, Decodable {
    var userName: String
    var email: String
    var userImage: String?
    var description: String?
    var sex: String
    var uid: String
    
    init(userName: String, email: String, userImage: String, description: String, sex: String, uid: String) {
        self.uid = uid
        self.email = email
        self.userName = userName
        self.sex = sex
        self.userImage = userImage
        self.description = description
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        guard let userName = data["userName"] as? String else { return nil }
        guard let uid = data["uid"] as? String else { return nil }
        guard let sex = data["sex"] as? String else { return nil }
        guard let email = data["email"] as? String else { return nil }
        
        self.uid = uid
        self.email = email
        self.userName = userName
        self.sex = sex
    }
    
    var representation: [String: Any] {
        var representation = ["userName": userName]
        representation["uid"] = uid
        representation["email"] = email
        representation["sex"] = sex
        representation["description"] = description
        representation["userImage"] = userImage
        return representation
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    
    static func == (lhs: MUser, rhs: MUser) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lowercasedFilter = filter.lowercased()
        return userName.lowercased().contains(lowercasedFilter)
    }
}
