//
//  MainTabBarController.swift
//  iChat
//
//  Created by Илья Синицын on 05.07.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
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
        
        let listViewController = ListViewController()
        let peopleViewController = PeopleViewController()
        
        guard let listImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfiguration),
              let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfiguration) else { return }
        
        viewControllers = [generateNavigationController(rootViewController: listViewController, titel: "Conversations", image: listImage), generateNavigationController(rootViewController: peopleViewController, titel: "People", image: peopleImage)]
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

