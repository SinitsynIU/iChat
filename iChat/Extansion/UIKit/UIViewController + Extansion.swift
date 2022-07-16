//
//  UIViewController + Extansion.swift
//  iChat
//
//  Created by Илья Синицын on 06.07.2022.
//

import UIKit

extension UIViewController {
    
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
}
