//
//  AppDelegate.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = MainCoordinator()
        window?.rootViewController = coordinator?.start()
        window?.makeKeyAndVisible()
        
        return true
    }
}

