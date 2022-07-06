//
//  ProtocolConfigurationCell.swift
//  iChat
//
//  Created by Илья Синицын on 06.07.2022.
//

import UIKit

protocol ProtocolConfigurationCell {
    
    static var reuseId: String { get }
    
    func configurationCell(with value: MChat)
}
