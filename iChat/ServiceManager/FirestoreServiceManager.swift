//
//  FirestoreServiceManager.swift
//  iChat
//
//  Created by Илья Синицын on 08.07.2022.
//

import Firebase
import FirebaseFirestore
import UIKit

class FirestoreServiceManager {
    
    static let shared = FirestoreServiceManager()
    
    let db = Firestore.firestore()
    
    private var userRef: CollectionReference {
        return db.collection("users")
    }
    
    var currentUser: MUser!
    
    func getUserData(user: User, completion: @escaping(Result<MUser, Error>) -> Void) {
        let docRef = userRef.document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let muser = MUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToMUser))
                    return
                }
                self.currentUser = muser
                completion(.success(muser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    func saveProfile(uid: String, email: String, userName: String?, userImage: UIImage?, description: String?, sex: String?, completion: @escaping(Result<MUser, Error>) -> Void) {
        guard Validators.isFiffedFirestore(userName: userName, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard userImage != #imageLiteral(resourceName: "avatar") else {
            completion(.failure(UserError.imageNotExist))
            return
        }
        
        var muser = MUser(userName: userName!, email: email, userImage: "", description: description!, sex: sex!, uid: uid)
        
        StorageServiceManager.shared.uploadImage(image: userImage!) { (result) in
            switch result {
            case .success(let url):
                muser.userImage = url.absoluteString
                self.userRef.document(muser.uid).setData(muser.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(muser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createWaitingChat(message: String, receiver: MUser, completion: @escaping(Result<Void, Error>) -> Void) {
        let reference = db.collection(["users", receiver.uid, "waitingChats"].joined(separator: "/"))
        let messageRef = reference.document(self.currentUser.uid).collection("messages")
        
        let massage = MMessage(user: currentUser, content: message)
        let chat = MChat(friendUserName: currentUser.userName, friendUserImage: currentUser.userImage, messageContent: massage.content, friendId: currentUser.uid)
        
        reference.document(currentUser.uid).setData(chat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageRef.addDocument(data: massage.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
 }
