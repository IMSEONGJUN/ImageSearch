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
        
        let favoriteImageCoordinator = FavoriteImageCoordinator()
        let favoriteImageViewController = favoriteImageCoordinator.start()
        favoriteImageViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        UITabBar.appearance().tintColor = .systemGreen
        UITabBar.appearance().backgroundColor = .systemBackground
        
        tabBarController.viewControllers = [imageSearchViewController, favoriteImageViewController]
        
        registerBaseViewController(tabBarController)
        
        return tabBarController
    }
}
