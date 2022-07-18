//
//  InsertableTextField.swift
//  iChat
//
//  Created by Илья Синицын on 07.07.2022.
//

import UIKit

class InsertableTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.placeholder = "Write something here..."
        self.font = UIFont.systemFont(ofSize: 14)
        self.clearButtonMode = .whileEditing
        self.borderStyle = .none
        self.layer.cornerRadius = 18
        self.layer.masksToBounds = true
        
        let image = UIImage(systemName: "smiley")
        let imageView = UIImageView(image: image)
        imageView.setupColor(color: .lightGray)
        self.leftView = imageView
        self.leftView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        self.leftViewMode = .always
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Sent"), for: .normal)
        button.applyGradients(cornerRadius: 10)
        self.rightView = button
        self.rightView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
        self.rightViewMode = .always
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x += -12
        return rect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
