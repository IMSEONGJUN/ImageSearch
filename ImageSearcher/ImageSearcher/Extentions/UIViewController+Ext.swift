//
//  UIViewController+Ext.swift
//
//  Created by SEONGJUN on 2020/10/09.
//

import UIKit
import SnapKit

extension UIViewController {
    func configureNavigationBar(with title: String, prefersLargeTitles: Bool) {
        navigationItem.title = title
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .tertiarySystemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func wrapNavigationController() -> UINavigationController {
        let navigationController = BaseNavigationController(rootViewController: self)
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
}
