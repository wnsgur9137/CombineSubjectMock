//
//  MainTabBarController.swift
//  SubjectMock
//
//  Created by JunHyeok Lee on 2023/06/08.
//

import UIKit

final class MainTabBarController: UITabBarController {
    fileprivate class NavigationTab: UINavigationController {
        init(rootViewController: UIViewController, title: String?, image: UIImage?, selectedImage: UIImage?) {
            super.init(rootViewController: rootViewController)
            self.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("NavigationTab has not been implemented")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [
            NavigationTab(rootViewController: HomeViewController(), title: "Home", image: nil, selectedImage: nil)
        ]
    }
}
