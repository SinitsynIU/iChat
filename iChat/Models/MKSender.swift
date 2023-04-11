//
//  MMessage.swift
//  iChat
//
//  Created by Илья Синицын on 17.07.2022.
//

import Foundation
import MessageKit

struct  MKSender: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
