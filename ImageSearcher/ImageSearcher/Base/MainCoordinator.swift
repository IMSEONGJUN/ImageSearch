//
//  MainCoordinator.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/31/23.
//

import UIKit

final class MainCoordinator: BaseCoordinator {
    override func start() -> UIViewController {
        let tabBarController = UITabBarController()
        let imageSearchCoordinator = ImageSearchCoordinator()
        let imageSearchViewController = imageSearchCoordinator.start()
        imageSearchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        tabBarController.viewControllers = [imageSearchViewController]
        
        registerBaseViewController(tabBarController)
        
        return tabBarController
    }
}
