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
        window?.rootViewController = createTabBar()
        window?.makeKeyAndVisible()
        
        configureNavigationBar()
        
        return true
    }
    
    func createTabBar() -> UITabBarController {
        let imageSearchCoordinator = ImageSearchCoordinator()
        let searchVC = imageSearchCoordinator.start()
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
//        let searchNavi = UINavigationController(rootViewController: searchVC)
        
        let favoritesListVC = FavoriteViewController(viewModel: FavoriteViewModel())
        favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        let favoritesNavi = UINavigationController(rootViewController: favoritesListVC)
        
        let tabbar = UITabBarController()
        UITabBar.appearance().tintColor = .systemGreen
        UITabBar.appearance().backgroundColor = .systemBackground
        tabbar.viewControllers = [searchVC, favoritesNavi]

        return tabbar
    }

    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemGreen
        UINavigationBar.appearance().backgroundColor = .systemBackground
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("@@@applicationWillResignActive")
        PersistenceManager.update()
    }
}

