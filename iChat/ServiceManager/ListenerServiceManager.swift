//
//  ListenerServiceManager.swift
//  iChat
//
//  Created by Илья Синицын on 17.07.2022.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerServiceManager {
    
    static let shared = ListenerServiceManager()
    
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    private var currentUsersId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func usersObserve(users: [MUser], completion: @escaping(Result<[MUser], Error>) -> Void) ->ListenerRegistration? {
        var users = users
        let usersListener = usersRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { (documentChange) in
                guard let muser = MUser(document: documentChange.document) else { return }
                switch documentChange.type {
                case .added:
                    guard !users.contains(muser) else { return }
                    guard muser.uid != self.currentUsersId else { return }
                    users.append(muser)
                case .modified:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users[index] = muser
                case .removed:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return usersListener
    }
}
