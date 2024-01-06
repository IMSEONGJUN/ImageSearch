//
//  FavoriteImageCoordinator.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 1/1/24.
//

import UIKit

final class FavoriteImageCoordinator: BaseCoordinator {
    override func start() -> UIViewController {
        let viewModel = FavoriteImageViewModel()
        let viewController = FavoriteImageViewController(viewModel: viewModel, coordinator: self)
        viewController.configureNavigationBar(with: NavigationBarTitle.favoriteImage, prefersLargeTitles: false)
        let navigationController = viewController.wrapNavigationController()
        registerBaseViewController(viewController)
        return navigationController
    }
    
    func showDetailImageViewController(imageUrlString: String) {
        let viewController = ImageDetailController(urlString: imageUrlString)
        baseViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
