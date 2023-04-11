//
//  MKImage.swift
//  iChat
//
//  Created by Илья Синицын on 10.04.2023.
//

import UIKit
import MessageKit

struct MKImage: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
