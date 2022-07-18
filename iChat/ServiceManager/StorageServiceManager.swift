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
}
