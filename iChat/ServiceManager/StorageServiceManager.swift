//
//  StorageServiceManager.swift
//  iChat
//
//  Created by Илья Синицын on 16.07.2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class StorageServiceManager {
    
    static let shared = StorageServiceManager()
    
    let storage = Storage.storage().reference()
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    private var avatarRef: StorageReference {
        return storage.child("avatars")
    }
    
    private var chatRef: StorageReference {
        return storage.child("chats")
    }
    
    func uploadImage(image: UIImage, completion: @escaping(Result<URL, Error>) -> Void) {
        guard let scaledImage = image.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        avatarRef.child(currentUserId).putData(imageData, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            
            self.avatarRef.child(self.currentUserId).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                
                completion(.success(downloadURL))
            }
        }
    }
    
    func uploadImageMessage(image: UIImage, to chat: MChat, completion: @escaping(Result<URL, Error>) -> Void) {
        guard let scaledImage = image.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        
        let user = Auth.auth().currentUser
        let chatName = [chat.friendUserName, "(\(chat.friendId))", (user?.displayName)!, "(\((user?.uid)!)"].joined()
       
        self.chatRef.child(chatName).child(imageName).putData(imageData, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            
            self.chatRef.child(chatName).child(imageName).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                
                completion(.success(downloadURL))
            }
        }
    }
    
    func downloadImage(url: URL, completion: @escaping(Result<UIImage?, Error>) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(UIImage(data: imageData)))
        }
    }
}
