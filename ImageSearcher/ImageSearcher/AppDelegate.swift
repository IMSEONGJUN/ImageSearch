//
//  AppDelegate.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = createTabBarController()
        window?.makeKeyAndVisible()
        
        configureNavigationBar()
        
        return true
    }
    
    func createTabBarController() -> UITabBarController {
        let imageSearchCoordinator = ImageSearchCoordinator()
        let imageSearchViewController = imageSearchCoordinator.start()
        imageSearchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let favoriteImageCoordinator = FavoriteImageCoordinator()
        let favoriteImageViewController = favoriteImageCoordinator.start()
        favoriteImageViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        let tabBarController = UITabBarController()
        UITabBar.appearance().tintColor = .systemGreen
        UITabBar.appearance().backgroundColor = .systemBackground
        tabBarController.viewControllers = [imageSearchViewController, favoriteImageViewController]

        return tabBarController
    }

    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemGreen
        UINavigationBar.appearance().backgroundColor = .systemBackground
    }
}

