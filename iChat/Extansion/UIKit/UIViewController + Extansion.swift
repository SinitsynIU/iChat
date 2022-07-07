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
}
