//
//  ListViewController.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit

class ListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
}

// MARK: - SetupUI
extension ListViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
    }
}

// MARK: - SetupConstraints
extension ListViewController {
    
    private func setupConstraints() {
        
    }
}

// MARK: - SwiftUI
import SwiftUI

struct ListViewControllerProvider: PreviewProvider {
    static var previews: some  View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = ListViewController()
         
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
