//
//  MainTabBarController.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let currentUser: MUser
    
    init(currentUser: MUser = MUser(userName: "nil", email: "nil", userImage: "", description: "nil", sex: "nil", uid: "nil")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarController()
    }
}

// MARK: - SetupUI
extension MainTabBarController {
    
    private func setupTabBarController() {
        tabBar.tintColor = .myPurple
        let boldConfiguration = UIImage.SymbolConfiguration(weight: .medium)
        
        let usersViewController = UsersViewController(currentUser: currentUser)
        let listViewController = ListViewController(currentUser: currentUser)
        
        guard let listImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfiguration),
              let userImage = UIImage(systemName: "person.2", withConfiguration: boldConfiguration) else { return }
        
        viewControllers = [
            generateNavigationController(rootViewController: usersViewController, titel: "People", image: userImage),
            generateNavigationController(rootViewController: listViewController, titel: "Conversations", image: listImage)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, titel: String, image: UIImage) -> UIViewController {
        let navigationViewController = UINavigationController(rootViewController: rootViewController)
        navigationViewController.tabBarItem.title = titel
        navigationViewController.tabBarItem.image = image
        return navigationViewController
    }
}

// MARK: - SwiftUI
import SwiftUI

struct MainTabBarControllerProvider: PreviewProvider {
    static var previews: some  View {
        
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = MainTabBarController()
         
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}

