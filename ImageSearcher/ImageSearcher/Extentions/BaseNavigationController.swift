//
//  BaseNavigationController.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 1/6/24.
//

import UIKit

class BaseNavigationController: UINavigationController {
    enum NavigationBarStyle {
        case translucent
        case none
    }
    
    var navigationBarStyle: NavigationBarStyle? {
        didSet {
            guard let navigationBarStyle = navigationBarStyle else {
                return
            }
            
            let isTranslucent = navigationBarStyle == .translucent
            navigationBar.isTranslucent = isTranslucent
            let appearance = UINavigationBarAppearance()
            if isTranslucent {
                appearance.configureWithTransparentBackground()
            } else {
                appearance.configureWithOpaqueBackground()
            }
            
            appearance.backgroundColor = .white
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.layoutIfNeeded()
        }
    }
}
