//
//  PeopleViewController.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit

class PeopleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
    }
}

// MARK: - SetupUI
extension PeopleViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
    }
}

// MARK: - SetupConstraints
extension PeopleViewController {
    
    private func setupConstraints() {
        
    }
}

// MARK: - SwiftUI
import SwiftUI

struct PeopleViewControllerProvider: PreviewProvider {
    static var previews: some  View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = PeopleViewController()
         
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
