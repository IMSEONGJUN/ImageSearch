//
//  ImageSearchCoordinator.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/31/23.
//

import UIKit

final class ImageSearchCoordinator: BaseCoordinator {
    override func start() -> UIViewController {
        let imageSearchUseCase = ImageSearchUseCase()
        let viewModel = ImageSearchViewModelNew(useCase: imageSearchUseCase)
        let viewController = ImageSearchViewControllerNew(viewModel: viewModel, coordinator: self)
        viewController.configureNavigationBar(with: NavigationBarTitle.imageSearchList, prefersLargeTitles: false)
        let navigationController = viewController.wrapNavigationController()
        registerBaseViewController(viewController)
        return navigationController
    }
}
