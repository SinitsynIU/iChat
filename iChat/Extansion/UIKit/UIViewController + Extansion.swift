//
//  UIViewController + Extansion.swift
//  iChat
//
//  Created by Илья Синицын on 06.07.2022.
//

import UIKit

extension UIViewController {
    
    enum SourceType {
        case photoLibrary
        case camera
    }
    
    func configurationCell<T: ProtocolConfigurationCell, U: Hashable>(collectionView:UICollectionView, cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Unable to dequeue \(cellType)") }
        cell.configurationCell(with: value)
        return cell
    }
    
    func showAlert(titel: String, message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: titel, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showActionSheetAlert(titel: String, message: String, titleActionFirst: String, titleActionSecond: String, completion: @escaping (SourceType) -> Void) {
        let actionSheet = UIAlertController(title: titel, message: message, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: titleActionFirst, style: .default, handler: { _ in
            completion(.photoLibrary)
            }))
        
        
        actionSheet.addAction(UIAlertAction(title: titleActionSecond, style: .default, handler: { _ in
            completion(.camera)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
            self.dismiss(animated: true)
        }))
    
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func subscribeToKeyboardShowHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardShowHide(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        self.view.frame.origin.y = -keyboardFrame.size.height / 2.8
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        self.view.frame.origin.y = 0
    }
    
    func dismissKey() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        resignFirstResponder()
    }
}
