//
//  FirestoreServiceManager.swift
//  iChat
//
//  Created by Илья Синицын on 08.07.2022.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirestoreServiceManager {
    
    static let shared = FirestoreServiceManager()
    
    let db = Firestore.firestore()
    
    private var userRef: CollectionReference {
        return db.collection("users")
    }
    
    func getUserData(user: User, completion: @escaping(Result<MUser, Error>) -> Void) {
        let docRef = userRef.document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let muser = MUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToMUser))
                    return
                }
                completion(.success(muser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    func saveProfile(uid: String, email: String, userName: String?, userImage: String?, description: String?, sex: String?, completion: @escaping(Result<MUser, Error>) -> Void) {
        guard Validators.isFiffedFirestore(userName: userName, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        let muser = MUser(userName: userName!, email: email, userImage: "", description: description!, sex: sex!, uid: uid)
        
        self.userRef.document(muser.uid).setData(muser.representation) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(muser))
            }
        }
    }
 }
