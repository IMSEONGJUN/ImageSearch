//
//  NavigationBarCustomizable.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 1/6/24.
//

import UIKit

protocol NavigationBarCustomizable: UIViewController {
    var navigationBarStyle: BaseNavigationController.NavigationBarStyle? { get }
}

class BaseNavigableViewController: UIViewController, NavigationBarCustomizable {
    var navigationBarStyle: BaseNavigationController.NavigationBarStyle? {
        BaseNavigationController.NavigationBarStyle.none
    }
}
