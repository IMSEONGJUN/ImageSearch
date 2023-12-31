//
//  BaseCoordinator.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import UIKit

class BaseCoordinator: Coordinator {
    weak var baseViewController: UIViewController?
    
    func start() -> UIViewController {
        UIViewController()
    }
    
    func registerBaseViewController(_ viewController: UIViewController) {
        baseViewController = viewController
    }
}
